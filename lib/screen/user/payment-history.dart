import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../../component/smallContainer.dart';
import '../../constant/constant.dart';
import 'paymentReceipt.dart';

class PaymentHistory extends StatefulWidget {
  PaymentHistory();

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  List patientData = [];
  var id;
  bool isLoading = false;

  showAlertSuccess() {
    // SweetAlert.show(
    //   context,
    //   style: SweetAlertStyle.success,
    //   title: "Passenger deleted successfully",
    //   subtitle: "You have deleted passenger record successfully",
    // );
  }

  Future<List> getUserData() async {
    SharedPreferences pred = await SharedPreferences.getInstance();
    final id = pred.getString('user_id');
    try {
      var res = await http.post(Uri.parse(myurl),
          body: {"request": "FETCH_MY_DESIGNS_PAYMENT", "id": id.toString()});

      setState(() {
        patientData = jsonDecode(res.body);
      });
    } catch (e) {
      print(e);
    }
    return patientData;
  }

  void initState() {
    getUserData();
    // highestBidder();
    profile();
    // print(patientData);
    super.initState();
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Row(
            children: <Widget>[
              new CircularProgressIndicator(),
              SizedBox(
                width: 25.0,
              ),
              Text("Please wait..."),
            ],
          ),
        );
      },
    );
  }

  String? name;
  profile() async {
    SharedPreferences pred = await SharedPreferences.getInstance();
    setState(() {
      name = pred.getString("name");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
          // centerTitle: true,
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: kDefault,
          title: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    size: 18,
                    Icons.arrow_back_ios_new_outlined,
                  ),
                  color: kWhite),
              SizedBox(
                width: 20,
              ),
              Text(
                "My Payment(s)",
                style: TextStyle(fontSize: 17),
              ),
            ],
          )),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
              future: getUserData(),
              builder: (context, AsyncSnapshot<List> snapshot) {
                var myData = snapshot.data;
                if (myData == null) {
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return myData.isNotEmpty
                      ? SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "My Order History",
                                      style: TextStyle(
                                          fontFamily: "Bold",
                                          fontSize: 18,
                                          color: kRed),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: patientData.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return ListContainer2(
                                      // iconPressed: () {
                                      // showAlertDialog(context);
                                      // },
                                      paymentDate: "${patientData[index]['created_at']}",
                                      amount:
                                          "₦${patientData[index]['amount']}",
                                      receipt:
                                          "${patientData[index]['ref_id']}",
                                      status:
                                          " ${patientData[index]['status']}",
                                      bookingDate:
                                          " ${patientData[index]['book_date']}",
                                      bookingTime:
                                          " ${patientData[index]['book_time']}",
                                      bookingAddress:
                                          " ${patientData[index]['address']}",

                                      counter: index + 1,
                                      viewBidder: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PaymentReciept(
                                                        patientData[index]
                                                            ['user_id'],
                                                        patientData[index]
                                                            ['ref_id'],
                                                        patientData[index]
                                                            ['amount'])));
                                        
                                      },
                                      prescribe: () {
                                        // confirmAlert(context,
                                        //     patientData[index]['payment_id']);
                                        // // Navigator.of(context).push(
                                        // //     MaterialPageRoute(
                                        // //         builder: ((context) =>
                                        // //             Prescription(
                                        // //                 patientData[index]
                                        // //                     ['p_id']))));
                                      },

                                      onPressed: () {
                                        
                                      },

                                      title: patientData[index]['category'],
                                      // subtitle: patientData[index]['name'],
                                    );
                                  }),
                            ],
                          ),
                        )
                      : Center(child: Text("No any payment history"));
                }
              }),
        ),
      ),
    );
  }
}
