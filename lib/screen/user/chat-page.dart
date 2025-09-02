import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // for timestamp formatting

import 'package:patient_blockhain/constant/constant.dart'; // Assuming kRed, kWhite, kDefault are here

class ChatPage extends StatefulWidget {
  final String userId;
  final String tailorId;
  final String tailorName;

  const ChatPage({
    super.key,
    required this.userId,
    required this.tailorId,
    required this.tailorName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(); // To auto-scroll
  bool isSending = false;
  bool isLoading = true;
  bool hasError = false; // New state for error handling

  @override
  void initState() {
    super.initState();
    _fetchMessages(); // Renamed to private
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Auto-scroll to the bottom when new messages arrive
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController
            .position
            .minScrollExtent, // minScrollExtent is the bottom for reverse: true
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _fetchMessages() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = await http.post(
        Uri.parse(myurl),
        body: {
          "request": "FETCH_CHAT_MESSAGES",
          "user_id": widget.userId,
          "tailor_id": widget.tailorId,
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success'] == true && result['messages'] is List) {
          setState(() {
            messages = List<Map<String, dynamic>>.from(result['messages']);
          });
          // Scroll to bottom after messages are loaded
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _scrollToBottom(),
          );
        } else {
          // Handle specific backend errors if needed
          setState(() => hasError = true);
          debugPrint('Backend error: ${result['message'] ?? 'Unknown error'}');
        }
      } else {
        setState(() => hasError = true);
        debugPrint('Server error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => hasError = true);
      debugPrint('Network/Parsing error fetching messages: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _sendMessage() async {
    final msg = _messageController.text.trim();
    if (msg.isEmpty) return;

    // Temporarily add the message to the UI for immediate feedback
    // Assign a temporary ID and a current timestamp
    final tempMessage = {
      'id': 'temp_${DateTime.now().millisecondsSinceEpoch}', // Unique temp ID
      'sender_id': widget.userId,
      'receiver_id': widget.tailorId,
      'message': msg,
      'created_at': DateTime.now().toIso8601String(),
      'status': 'sending', // Custom status for UI
    };

    setState(() {
      messages.insert(0, tempMessage); // Add to top for reverse list
      isSending = true;
    });
    _messageController.clear(); // Clear input field immediately
    _scrollToBottom(); // Scroll to the new message

    try {
      final response = await http.post(
        Uri.parse(myurl),
        body: {
          "request": "SEND_CHAT_MESSAGE",
          "sender_id": widget.userId,
          "receiver_id": widget.tailorId,
          "message": msg,
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success'] == true) {
          // Message successfully sent, now update its status or re-fetch
          // A full re-fetch is simpler for now, but a local update is more performant
          await _fetchMessages(); // Re-fetch to get the official message ID and timestamp
        } else {
          debugPrint(
            'Failed to send message: ${result['message'] ?? 'Unknown error'}',
          );
          // Update temp message to 'failed' status
          _updateMessageStatus(tempMessage['id'] as String, 'failed');
        }
      } else {
        debugPrint('Server error sending message: ${response.statusCode}');
        _updateMessageStatus(tempMessage['id'] as String, 'failed');
      }
    } catch (e) {
      debugPrint('Network/Parsing error sending message: $e');
      _updateMessageStatus(tempMessage['id'] as String, 'failed');
    } finally {
      setState(() => isSending = false);
    }
  }

  void _updateMessageStatus(String tempId, String status) {
    setState(() {
      final index = messages.indexWhere((msg) => msg['id'] == tempId);
      if (index != -1) {
        messages[index]['status'] = status;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kRed, // Consistent primary color
        foregroundColor: kWhite, // Text color
        elevation: 4, // Subtle shadow for depth
        shadowColor: Colors.black.withOpacity(0.2),
        title: Row(
          children: [
            CircleAvatar(
              // You might want to use a dynamic image for the tailor here if available
              // For now, using a placeholder image from your constant or a default icon
              backgroundImage: const AssetImage(
                'img/admin.jpg',
              ), // Placeholder or tailor's actual profile pic
              radius: 20, // Slightly larger avatar
              backgroundColor: kWhite.withOpacity(0.8), // A subtle background
              child: Image.asset('img/admin.jpg').image == null
                  ? Icon(Icons.person, color: kRed, size: 20) // Fallback icon
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.tailorName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(kRed),
                    ),
                  )
                : hasError
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wifi_off,
                          color: Colors.red.shade400,
                          size: 60,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Couldn't load messages. Check your connection.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: _fetchMessages,
                          icon: const Icon(Icons.refresh),
                          label: const Text("Retry"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kRed,
                            foregroundColor: kWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.grey,
                          size: 60,
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Start a conversation with ${widget.tailorName}!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController, // Assign scroll controller
                    reverse: true, // Show latest message at bottom
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg =
                          messages[index]; // Use directly as list is reversed
                      final isMine = msg['sender_id'] == widget.userId;
                      final timestamp = DateFormat(
                        'hh:mm a',
                      ).format(DateTime.parse(msg['created_at']));

                      // Determine bubble color
                      Color messageColor = isMine ? kRed : Colors.grey.shade200;
                      Color textColor = isMine ? kWhite : Colors.black87;
                      Color timestampColor = isMine
                          ? kWhite.withOpacity(0.7)
                          : Colors.grey.shade600;

                      // Adjust border radius for message "tail"
                      BorderRadius messageBorderRadius = BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isMine
                            ? const Radius.circular(16)
                            : const Radius.circular(4),
                        bottomRight: isMine
                            ? const Radius.circular(4)
                            : const Radius.circular(16),
                      );

                      Icon? statusIcon;
                      if (isMine) {
                        if (msg['status'] == 'sending') {
                          statusIcon = const Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.white70,
                          );
                        } else if (msg['status'] == 'failed') {
                          statusIcon = const Icon(
                            Icons.error_outline,
                            size: 14,
                            color: Colors.orangeAccent,
                          );
                        } else {
                          // Assuming 'delivered' or 'sent' status
                          statusIcon = const Icon(
                            Icons.done_all,
                            size: 14,
                            color: Colors.white70,
                          );
                        }
                      }

                      return Align(
                        alignment: isMine
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: messageColor,
                            borderRadius: messageBorderRadius,
                          ),
                          child: Column(
                            crossAxisAlignment: isMine
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg['message'],
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisSize: MainAxisSize
                                    .min, // Make row only as wide as its children
                                children: [
                                  Text(
                                    timestamp,
                                    style: TextStyle(
                                      color: timestampColor,
                                      fontSize: 11,
                                    ),
                                  ),
                                  if (statusIcon != null) ...[
                                    const SizedBox(width: 4),
                                    statusIcon,
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Message Input Area
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: kWhite, // Background for the input bar
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onChanged: (_) => setState(
                      () {},
                    ), // Trigger rebuild for send button state
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor:
                          Colors.grey[100], // Lighter background for text field
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        // Consistent border for enabled state
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        // Slight border on focus
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: kRed.withOpacity(0.6),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Material(
                  color: (_messageController.text.trim().isEmpty || isSending)
                      ? Colors.grey
                      : kRed,
                  borderRadius: BorderRadius.circular(25),
                  child: InkWell(
                    onTap: (_messageController.text.trim().isEmpty || isSending)
                        ? null
                        : _sendMessage,
                    borderRadius: BorderRadius.circular(25),
                    child: Padding(
                      padding: const EdgeInsets.all(
                        12.0,
                      ), // Adjust padding for button size
                      child: isSending
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  kWhite,
                                ),
                              ),
                            )
                          : Icon(Icons.send, color: kWhite, size: 24),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
