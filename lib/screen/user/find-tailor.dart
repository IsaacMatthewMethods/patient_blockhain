import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:patient_blockhain/screen/user/chat-page.dart'; // Ensure this path is correct
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart'; // Ensure toast package is correctly initialized/used
import '../../constant/constant.dart'; // For kRed, kWhite, etc.

class FindTailorsPage extends StatefulWidget {
  const FindTailorsPage({Key? key}) : super(key: key);

  @override
  State<FindTailorsPage> createState() => _FindTailorsPageState();
}

class _FindTailorsPageState extends State<FindTailorsPage> {
  List tailors = [];
  List filteredTailors = [];
  bool isLoading = true;
  bool hasError = false;
  String currentUserId = ''; // This will be the customer's ID
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ToastContext().init(context); // Initialize ToastContext
    _loadUserProfile(); // Renamed to private
    _fetchTailors(); // Renamed to private
    searchController.addListener(_filterTailors);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString("user_id") ?? '';
    });
  }

  void _filterTailors() {
    String query = searchController.text.toLowerCase();
    setState(() {
      // If the search query is empty, show all tailors
      if (query.isEmpty) {
        filteredTailors = List.from(
          tailors,
        ); // Create a new list to avoid modifying original
      } else {
        filteredTailors = tailors.where((tailor) {
          final name = (tailor["full_name"] ?? "").toLowerCase();
          final address = (tailor["address"] ?? "").toLowerCase();
          // You might also add other fields like 'specialty', 'experience' if they exist
          return name.contains(query) || address.contains(query);
        }).toList();
      }
    });
  }

  Future<void> _fetchTailors() async {
    // Renamed to private
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = await http.post(
        Uri.parse(myurl),
        body: {'request': 'USER_FETCH_TAILORS'},
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        if (result['success'] == true && result['tailors'] is List) {
          setState(() {
            tailors = result['tailors'];
            filteredTailors = List.from(tailors); // Initialize filtered list
            isLoading = false;
          });

          if (tailors.isEmpty) {
            Toast.show(
              "No tailors found at the moment.",
              duration: Toast.lengthShort,
              gravity: Toast.center,
            );
          }
        } else {
          setState(() {
            isLoading = false;
            hasError = true;
          });
          Toast.show(
            "Failed to load tailors: Invalid response.",
            duration: Toast.lengthShort,
            gravity: Toast.center,
          );
        }
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
        });
        Toast.show(
          "Failed to connect to server. Status: ${response.statusCode}",
          duration: Toast.lengthShort,
          gravity: Toast.center,
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      Toast.show(
        "Network error: $e",
        duration: Toast.lengthLong,
        gravity: Toast.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Find Tailors",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: kRed, // Consistent with dashboard
        foregroundColor: kWhite,
        elevation: 4, // Subtle shadow
        shadowColor: Colors.black.withOpacity(0.2),
      ),
      body: Column(
        children: [
          // Search Bar Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search tailors by name or location...',
                prefixIcon: Icon(Icons.search, color: kRed), // Icon color
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15), // More rounded
                  borderSide: BorderSide.none, // No border for cleaner look
                ),
                filled: true,
                fillColor: Colors.grey[100], // Light fill color
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
              ),
            ),
          ),
          // Conditional Content Display
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : hasError
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: kRed, size: 50),
                        const SizedBox(height: 15),
                        const Text(
                          "Failed to load tailors.",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: _fetchTailors,
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
                : filteredTailors.isEmpty && searchController.text.isNotEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_off, color: Colors.grey, size: 50),
                        SizedBox(height: 15),
                        Text(
                          "No tailors match your search.",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ],
                    ),
                  )
                : filteredTailors
                      .isEmpty // No tailors at all
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.storefront_outlined,
                          color: Colors.grey,
                          size: 50,
                        ),
                        SizedBox(height: 15),
                        Text(
                          "No tailors registered yet.",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: filteredTailors.length,
                    itemBuilder: (context, index) {
                      final tailor = filteredTailors[index];
                      return TailorCard(
                        tailor: tailor,
                        currentUserId: currentUserId,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// --- Custom Tailor Card Widget ---
class TailorCard extends StatelessWidget {
  final Map<String, dynamic> tailor;
  final String currentUserId;

  const TailorCard({
    Key? key,
    required this.tailor,
    required this.currentUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 5, // More pronounced shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Consistent rounded corners
      ),
      child: InkWell(
        // Use InkWell for better tap feedback
        onTap: () {
          // Potentially navigate to a Tailor Profile/Details Page here
          // For now, it routes to chat as per original logic
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                userId: currentUserId,
                tailorId: tailor['id'],
                tailorName: tailor['full_name'] ?? 'Unnamed Tailor',
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tailor Avatar/Image (Placeholder for now, could be dynamic later)
              CircleAvatar(
                radius: 30, // Slightly larger avatar
                backgroundColor: Colors.grey[200],
                child: Icon(Icons.person, color: kRed, size: 30),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tailor["full_name"] ?? "Unnamed Tailor",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            tailor["address"] ?? "No address provided",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Add more details here if available from backend, e.g., rating, specialty
                    // Example:
                    // Row(
                    //   children: [
                    //     Icon(Icons.star, size: 16, color: Colors.amber),
                    //     SizedBox(width: 4),
                    //     Text("${tailor["rating"] ?? "N/A"} (${tailor["reviews"] ?? "0"} reviews)"),
                    //   ],
                    // ),
                    // SizedBox(height: 4),
                    // Text("Specialty: ${tailor["specialty"] ?? "General Tailoring"}"),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.chat_bubble_outline,
                      color: kRed,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            userId: currentUserId,
                            tailorId: tailor['id'],
                            tailorName: tailor['full_name'] ?? 'Unnamed Tailor',
                          ),
                        ),
                      );
                    },
                    tooltip:
                        "Chat with ${tailor['full_name']?.split(' ').first ?? 'tailor'}",
                  ),
                  // If you have a phone number, add a call button
                  // IconButton(
                  //   icon: Icon(Icons.call, color: Colors.green),
                  //   onPressed: () {
                  //     // Implement call functionality
                  //   },
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
