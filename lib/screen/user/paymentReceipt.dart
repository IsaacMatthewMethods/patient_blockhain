import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constant/constant.dart';
class PaymentReciept extends StatefulWidget {
  final String userId;
  final String orderID;
  final dynamic amount;

  const PaymentReciept(this.userId, this.orderID, this.amount, {Key? key}) : super(key: key);

  @override
  State<PaymentReciept> createState() => _PaymentRecieptState();
}

class _PaymentRecieptState extends State<PaymentReciept> {
  late Future<List> paymentDataFuture;

  @override
  void initState() {
    super.initState();
    paymentDataFuture = fetchPaymentData();
  }

  Future<List> fetchPaymentData() async {
    try {
      final response = await http.post(Uri.parse(myurl), body: {
        "request": "FETCH_HENNA_PAYMENT",
        "user_id": widget.userId,
        "refID": widget.orderID,
      });

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to load payment data');
      }
    } catch (e) {
      print("Payment fetch error: $e");
      return [];
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFF7F8FA), // Light Apple-style background
    appBar: AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        "Henna Receipt",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.black),
    ),
    body: FutureBuilder<List>(
      future: paymentDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No booking data found."));
        }

        final item = snapshot.data![0];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ✅ Success Animation
                Center(child: Image.asset("img/success.gif", height: 160)),

                const SizedBox(height: 20),

                /// 🔖 Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Henna by H&S",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(height: 4),
                        Text("Booking Successful",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            )),
                      ],
                    ),
                    Image.asset("img/barcode.png", width: 48),
                  ],
                ),

                const SizedBox(height: 20),
                _buildRow("Receipt No.", item['ref_id']),
                _buildRow("Customer", item['full_name']),
                _buildRow("Phone", item['phone']),
                _buildRow("Location", item['address']),

                const SizedBox(height: 16),

                /// 🖼️ Design Image + Info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "$imgUrl${item['image_url']}",
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Design Name:",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          Text(item['title'] ?? '', style: const TextStyle(color: Colors.black87)),
                          const SizedBox(height: 8),
                          const Text("Description:",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          Text(item['description'] ?? '', style: const TextStyle(color: Colors.black87)),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                _buildRow("Email", item['email']),
                _buildRow("Booking Date", item['created_at']),

                const SizedBox(height: 16),

                /// 💰 Amount & Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black, fontSize: 16),
                        children: [
                          const TextSpan(
                            text: "Paid: ",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: "₦${item['amount']}",
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item['status'] ?? "Success",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// 🧾 Footer
                Center(
                  child: Column(
                    children: [
                      Image.asset("img/pay.jpeg", width: 60),
                      const SizedBox(height: 8),
                      Container(
                          width: 120, height: 1.0, color: Colors.black12),
                      const SizedBox(height: 6),
                      const Text("H&S Henna Studio",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500)),
                      const Text("Authentic Traditional Art",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
Widget _buildRow(String label, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: 15,
            )),
        Flexible(
          child: Text(
            value ?? '',
            textAlign: TextAlign.right,
            style: const TextStyle(color: Colors.black54, fontSize: 15),
          ),
        ),
      ],
    ),
  );
}
}