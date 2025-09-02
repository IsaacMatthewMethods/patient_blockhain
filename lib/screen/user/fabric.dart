import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:patient_blockhain/constant/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat-page.dart';
import 'paymentReceipt.dart'; // Assuming kRed, kWhite, myurl, and imgUrl are here
// Import your ChatPage if you want to navigate to it
// import 'package:henna/chat_page.dart'; // Assuming your ChatPage file location

class FabricListPage extends StatefulWidget {
  // If you want to enable direct DM to a specific tailor from this list,
  // you might need to pass tailor information to this page,
  // or retrieve it dynamically (e.g., if fabrics are always from one tailor).
  // For demonstration, I'll use placeholder values.
  final String? currentUserId; // User ID of the logged-in user
  final String? defaultTailorId; // Default tailor to DM if needed
  final String? defaultTailorName; // Default tailor name

  const FabricListPage({
    super.key,
    this.currentUserId,
    this.defaultTailorId,
    this.defaultTailorName,
  });

  @override
  State<FabricListPage> createState() => _FabricListPageState();
}

class _FabricListPageState extends State<FabricListPage> {
  List<dynamic> fabrics = [];
  bool isLoading = true;
  bool hasError = false; // New state for error handling
  Map<String, int> selectedQuantities =
      {}; // Stores selected quantity per fabric ID

  String currentUserId = '';
  Random random = new Random();

  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId =
          prefs.getString("user_id") ?? '0'; // More user-friendly default
    });
  }

  Future<void> _fetchFabrics() async {
    setState(() {
      isLoading = true;
      hasError = false; // Reset error state
    });
    try {
      final response = await http.post(
        Uri.parse(myurl),
        body: {"request": "GET_ALL_FABRICS"},
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result is List) {
          // Ensure the result is a list
          setState(() {
            fabrics = result;
            for (var fabric in fabrics) {
              final id = fabric['fabric_id'].toString();
              selectedQuantities.putIfAbsent(
                id,
                () => 1,
              ); // Initialize quantity to 1
            }
          });
        } else {
          // Handle cases where the backend returns success: false or not a list
          setState(() => hasError = true);
          debugPrint('Unexpected response format: $result');
        }
      } else {
        setState(() => hasError = true);
        debugPrint('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error loading fabrics: $e");
      setState(() => hasError = true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Function to navigate to the chat page
  void _navigateToChatWithTailor() {
    if (widget.currentUserId == null ||
        widget.defaultTailorId == null ||
        widget.defaultTailorName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tailor information not available for chat.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // For demonstration, navigate to a placeholder if ChatPage isn't set up
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Navigating to chat with ${widget.defaultTailorName ?? "Tailor"} (Feature coming soon!).',
        ),
        backgroundColor: Colors.blueAccent,
      ),
    );
    debugPrint(
      'Navigating to chat with tailor ID: ${widget.defaultTailorId}, Name: ${widget.defaultTailorName}',
    );
  }

  // int? amountPayable;
  int? orderID;
  String? refID;

  var publicKey = 'pk_test_cb3cf3b37036d460af816b0192bb9d1fa164826e';
  final plugin = PaystackPlugin();

  void payment(price) async {
    SharedPreferences pred = await SharedPreferences.getInstance();
    final email = pred.getString("email");
    int amount = int.parse(price) * 1000;
    Charge charge = Charge()
      ..amount = amount
      ..reference = "ref${DateTime.now()}"
      // or ..accessCode = _getAccessCodeFrmInitialization()
      ..email = email
      ..currency = "NGN";

    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );

    if (response.status == true) {
      Navigator.of(context, rootNavigator: true).pop();
      _updateUserTransaction(price);
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => GenerateUser(user_id, orderID)));
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      print("Failed to make payment");
    }
  }

  String _getReference() {
    return '${DateTime.now().millisecondsSinceEpoch}';
  }

  _confirmOrder(price, food_id) async {
    // setState(() {
    //   isLoading = true;
    // });

    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kRed),
        ),
      ),
    );

    // Then do the work
    await _initiateUserTransaction(price, food_id);

    // Dialog will be closed in _updateUserTransaction after success
  }

  _initiateUserTransaction(price, food_id) async {
    SharedPreferences pred = await SharedPreferences.getInstance();
    final user_id = pred.getString("user_id");
    final response = await http.post(
      Uri.parse(myurl),
      body: {
        "request": "INITIATE TRANSACTION",
        "user_id": user_id.toString(),
        "fabric_id": food_id.toString(),
        "amount": price.toString(),
        "ref": orderID.toString(),
      },
    );

    if (response.statusCode == 200) {
      payment(price);
    }
  }

  _updateUserTransaction(price) async {
    SharedPreferences pred = await SharedPreferences.getInstance();
    final user_id = pred.getString("user_id");
    final response = await http.post(
      Uri.parse(myurl),
      body: {
        "request": "UPDATE TRANSACTION",
        "user_id": user_id.toString(),
        "ref": orderID.toString(),
        // "orderID": orderID.toString(),d
        // "accountNo": acoountNo.toString()
      },
    );

    if (response.statusCode == 200) {
      Navigator.of(
        context,
        rootNavigator: true,
      ).pop(); // Close the loading dialog

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => PaymentReciept("$user_id", "$orderID", price),
        ),
      );
    }
  }

  bool customePay = false;
  String action = "";

  String toNaira(int amount) {
    var nairaFormatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦');
    String formattedAmount = nairaFormatter.format(amount);
    // print(formattedAmount); // Outputs: ₦1,234.56
    return formattedAmount;
  }

  // Sample data for the menu items

  void initState() {
    super.initState();
    _fetchFabrics(); // Renamed to private
    _loadUserProfile();
    plugin.initialize(publicKey: publicKey);
    orderID = random.nextInt(1000000000);
    refID = _getReference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Fabrics"),
        backgroundColor: kRed, // Use your app's primary color
        foregroundColor:
            kWhite, // Use your app's primary text color for contrast
        elevation: 4, // Add a subtle shadow
        actions: [
          // DM icon to message the tailor
          if (widget.defaultTailorId != null && widget.currentUserId != null)
            IconButton(
              icon: const Icon(Icons.message_rounded),
              tooltip: 'Message Tailor',
              onPressed: _navigateToChatWithTailor,
            ),
          const SizedBox(width: 8), // Spacing from edge
        ],
      ),
      body: isLoading
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
                    Icons.error_outline,
                    color: Colors.red.shade400,
                    size: 60,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Failed to load fabrics. Please try again.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _fetchFabrics,
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
          : fabrics.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.style, color: Colors.grey, size: 60),
                  SizedBox(height: 15),
                  Text(
                    "No fabrics found at the moment.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: fabrics.length,
              itemBuilder: (context, index) {
                final fabric = fabrics[index];
                final String fabricId = fabric['fabric_id'].toString();
                final int availableQuantity =
                    int.tryParse(fabric['quantity'].toString()) ?? 0;
                final int currentSelectedQuantity =
                    selectedQuantities[fabricId] ?? 1;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 6.0, // Increased shadow for more depth
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      15.0,
                    ), // More rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Fabric Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ), // Consistent image border
                              child:
                                  fabric['image_url'] != null &&
                                      fabric['image_url'].isNotEmpty
                                  ? Image.network(
                                      "${imgUrl}${fabric['image_url']}",
                                      width: 110, // Slightly larger image
                                      height: 110,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (
                                            context,
                                            error,
                                            stackTrace,
                                          ) => Container(
                                            width: 110,
                                            height: 110,
                                            color: Colors
                                                .grey
                                                .shade200, // Placeholder background
                                            child: Icon(
                                              Icons.image_not_supported,
                                              size: 50,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                    )
                                  : Container(
                                      width: 110,
                                      height: 110,
                                      color: Colors.grey.shade200,
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 18.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fabric['name'] ?? 'Unknown Fabric',
                                    style: const TextStyle(
                                      fontSize: 20.0, // Larger title
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    maxLines:
                                        1, // Prevent long names from pushing down
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6.0),
                                  Text(
                                    fabric['description'] ??
                                        'No description available.',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey.shade600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    'Price: ₦${fabric['price'] ?? 'N/A'}', // Use Naira symbol
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0,
                                      color:
                                          kRed, // Use primary color for price
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    "Available: ${fabric['quantity'] ?? '0'}",
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      color: availableQuantity > 0
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        // Quantity Selector and Add to Cart Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.remove_circle_outline,
                                    color: kRed,
                                  ),
                                  onPressed: currentSelectedQuantity > 1
                                      ? () {
                                          setState(() {
                                            selectedQuantities[fabricId] =
                                                currentSelectedQuantity - 1;
                                          });
                                        }
                                      : null, // Disable if quantity is 1
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    currentSelectedQuantity.toString(),
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.add_circle_outline,
                                    color: kRed,
                                  ),
                                  onPressed:
                                      currentSelectedQuantity <
                                          availableQuantity // Disable if maxed out
                                      ? () {
                                          setState(() {
                                            selectedQuantities[fabricId] =
                                                currentSelectedQuantity + 1;
                                          });
                                        }
                                      : null,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // addToCart(fabric, selectedQuantities[fabricId]!);
                                    _confirmOrder(
                                      fabric['price'],
                                      fabric['fabric_id'],
                                    );
                                  },
                                  icon: const Icon(Icons.shopping_cart),
                                  label: const Text("Place order"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(
                                    Icons.chat_bubble_outline,
                                    color: Colors.teal,
                                  ),
                                  tooltip: "DM Tailor",
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          userId: currentUserId,
                                          tailorId: fabric['tailor_id'],
                                          tailorName:
                                              fabric['full_name'] ?? 'Tailor',
                                        ),
                                      ),
                                    );
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (_) => ChatPage(
                                    //       tailorId: fabric['tailor_id'].toString(),
                                    //       tailorName: fabric['tailor_name'] ?? "Tailor",
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
