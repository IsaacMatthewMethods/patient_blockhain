import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:patient_blockhain/constant/constant.dart';
import 'package:patient_blockhain/screen/user/paymentReceipt.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ExploreDesignsPage extends StatefulWidget {
  @override
  _ExploreDesignsPageState createState() => _ExploreDesignsPageState();
}

class _ExploreDesignsPageState extends State<ExploreDesignsPage> {
  List designs = [];
  bool loading = true;

  Future<List> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    try {
      var res = await http.post(
        Uri.parse(myurl), // replace with your actual API URL
        body: {"request": "FETCH_ALL_HENNA_DESIGNS"},
      );

      setState(() {
        designs = jsonDecode(res.body);
        loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
    }
    return designs;
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Light grey bg for contrast
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Explore Henna & Hair Designs",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : designs.isEmpty
          ? const Center(child: Text("No designs available"))
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.65,
              ),
              itemCount: designs.length,
              itemBuilder: (context, index) {
                final item = designs[index];
                return DesignCard(
                  id: item['artist_design_id'],
                  title: item['title'],
                  imageUrl: "$imgUrl" + item['image_url'],
                  price: "${item['price']}",
                  category: item['category'],
                );
              },
            ),
    );
  }
}

class DesignCard extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final String price;
  final String category;

  const DesignCard({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DesignDetailsPage(
              id: id,
              title: title,
              imageUrl: imageUrl,
              price: price,
              category: category,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1, // makes it a perfect square image
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.broken_image)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 5, 12, 10),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Bold",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "₦$price",
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: "",
                    color: Colors.black87,
                  ),
                ),
              ),
              sizedBox,
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                child: Text(
                  category,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DesignDetailsPage extends StatefulWidget {
  final String id;
  final String title;
  final String imageUrl;
  final String price;
  final String category;

  const DesignDetailsPage({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.category,
  });

  @override
  State<DesignDetailsPage> createState() => _DesignDetailsPageState();
}

class _DesignDetailsPageState extends State<DesignDetailsPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController addressController = TextEditingController();

  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  void handleBooking(price, design_id) {
    ToastContext().init(context);
    if (selectedDate == null ||
        selectedTime == null ||
        addressController.text.isEmpty) {
      Toast.show(
        "All Fields are required",
        duration: Toast.lengthLong,
        backgroundColor: Colors.red,
        gravity: Toast.center,
      );
      return;
    }

    _confirmOrder(price, design_id);

    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text("Booking successful!")),
    // );
  }

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

  // int? amountPayable;
  int? orderID;
  String? refID;

  var publicKey = 'pk_test_cb3cf3b37036d460af816b0192bb9d1fa164826e';
  final plugin = PaystackPlugin();

  void payment(String price) async {
    SharedPreferences pred = await SharedPreferences.getInstance();
    final email = pred.getString("email");

    int amount = (double.parse(price).toInt()) * 100;

    Charge charge = Charge()
      ..amount = amount
      ..reference = "ref${DateTime.now()}"
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
        "request": "INITIATE_HENNA_TRANSACTION",
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
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
    final formattedTime = selectedTime!.format(context);
    final user_id = pred.getString("user_id");
    final response = await http.post(
      Uri.parse(myurl),
      body: {
        "request": "UPDATE_HENNA_TRANSACTION",
        "user_id": user_id.toString(),
        "ref": orderID.toString(),
        "book_date": formattedDate,
        "book_time": formattedTime,
        "address": addressController.text,
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
    _loadUserProfile();
    plugin.initialize(publicKey: publicKey);
    orderID = random.nextInt(1000000000);
    refID = _getReference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Light grey bg for contrast
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Design Details",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                widget.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              "₦${widget.price}",
              style: const TextStyle(
                fontSize: 22,
                color: Colors.black87,
                fontFamily: "",
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "Category: ${widget.category}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            const Text(
              "Choose Booking Date",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: pickDate,
              icon: const Icon(Icons.date_range, color: Colors.black54),
              label: Text(
                selectedDate == null
                    ? "Select Date"
                    : DateFormat('yyyy-MM-dd').format(selectedDate!),
                style: const TextStyle(color: Colors.black87),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Choose Time",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: pickTime,
              icon: const Icon(Icons.access_time, color: Colors.black54),
              label: Text(
                selectedTime == null
                    ? "Select Time"
                    : selectedTime!.format(context),
                style: const TextStyle(color: Colors.black87),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Enter Your Address",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: addressController,
              maxLines: 2,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Type address here...",
                contentPadding: const EdgeInsets.all(14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton.icon(
                onPressed: () => handleBooking("${widget.price}", widget.id),
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text("Book Now", style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
