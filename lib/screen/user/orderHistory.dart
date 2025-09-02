import 'package:flutter/material.dart';

class PaymentHistoryPage extends StatelessWidget {
  final List<Payment> payments;

  PaymentHistoryPage({required this.payments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History'),
      ),
      body: ListView.builder(
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final payment = payments[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            elevation: 4.0,
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              title: Text('Order ID: ${payment.orderId}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Shop: ${payment.shopName}'),
                  Text('Amount: \$${payment.amount}'),
                  Text('Status: ${payment.paymentStatus}'),
                  Text('Method: ${payment.paymentMethod}'),
                  Text('Date: ${payment.paymentDate.toLocal()}'),
                ],
              ),
              isThreeLine: true,
              trailing: Icon(Icons.payment),
            ),
          );
        },
      ),
    );
  }
}

class Payment {
  final int paymentId;
  final int orderId;
  final String paymentStatus;
  final String paymentMethod;
  final double amount;
  final DateTime paymentDate;
  final String shopName; // Added field

  Payment({
    required this.paymentId,
    required this.orderId,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.amount,
    required this.paymentDate,
    required this.shopName, // Added parameter
  });
}
