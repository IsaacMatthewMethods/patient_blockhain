import 'dart:async';
import 'package:flutter/material.dart';
import '../../constant/constant.dart';
import 'paymentReceipt.dart';

List payemntData = [];

class GenerateUser extends StatefulWidget {
  final user_id, orderID, amount;
  const GenerateUser(
    this.user_id,
    this.orderID,
    this.amount, {super.key},
  );

  @override
  State<GenerateUser> createState() => _GenerateUserState();
}

class _GenerateUserState extends State<GenerateUser> {
  var user_id;

  @override
  void initState() {
    Timer(Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                PaymentReciept(widget.user_id, widget.orderID, widget.amount)));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateToday = DateTime.now();
    String date = dateToday.toString().substring(0, 10);

    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kDefault,
        title: Text(" Reciept"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: payemntData.isEmpty
            ? CircularProgressIndicator(
                color: kDefault,
                strokeWidth: 2.0,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image(
                      image: AssetImage(
                        "img/success.gif",
                      ),
                      // height: 200,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Payment Received! ",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Bold",
                                color: Colors.green),
                          ),
                          Text(
                            "Thank you for your donation",
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Divider(),

                  sizedBox,
                ],
              ),
      ),
    );
  }
}
