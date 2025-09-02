import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import '../../component/button.dart';
import '../../component/inputs.dart';
import '../../component/skelaton.dart';
import '../../constant/constant.dart';

class SuccessPayment extends StatefulWidget {
  final amount, user_id, type;
  SuccessPayment(this.amount, this.user_id, this.type);

  @override
  State<SuccessPayment> createState() => _SuccessPaymentState();
}

class _SuccessPaymentState extends State<SuccessPayment> {
  var name, email, username;
  final _formKey = GlobalKey<FormState>();

  TextEditingController amount = new TextEditingController();

  bool ActiveConnection = false;
  String T = "";
  var bidder_id;
  bool isLoading = false;
  bool _processing = false;

  register() async {
    ToastContext().init(context);
    SharedPreferences pred = await SharedPreferences.getInstance();
    setState(() {
      bidder_id = pred.getString("bidder_id");
    });

    if (_formKey.currentState!.validate()) {
      var connectedResult = await Connectivity().checkConnectivity();
      if (connectedResult == ConnectivityResult.mobile ||
          connectedResult == ConnectivityResult.wifi) {
        setState(() {
          isLoading = true;
        });
        isLoading
            ? loadingAlert(context)
            : Navigator.of(context, rootNavigator: true).pop('dialog');
        Timer(Duration(seconds: 3), () {});

        final res = await http.post(Uri.parse(myurl), body: {
          "request": "payment_platform",
          "amount": amount.text,
          "bidder_id": bidder_id,
          // "item_id": widget.item_id,
        });

        if (jsonDecode(res.body) == "exits") {
          setState(() {
            isLoading = false;
          });
          !isLoading
              ? Navigator.of(context).pop('dialog')
              : loadingAlert(context);
          Toast.show("Already payment_platforming",
              duration: Toast.lengthShort, gravity: Toast.bottom);

          warningAlert(
              context, "You have already payment_platforming with this amount");
        } else {
          if (jsonDecode(res.body) == "success") {
            setState(() {
              isLoading = false;
            });
            !isLoading
                ? Navigator.of(context).pop('dialog')
                : loadingAlert(context);
            setState(() {
              isLoading = true;
            });
            Toast.show("successfully",
                duration: Toast.lengthShort, gravity: Toast.bottom);

            successAlert(context, "You have payment_platforming on this item");
            // reg_no.clear();
            // password.clear();
          } else {
            Toast.show("Error occured pls try again!",
                duration: Toast.lengthShort, gravity: Toast.bottom);
          }
        }
      } else {
        _Connectivity();
      }
      setState(() {
        _processing = false;
      });
    }
  }

  profile() async {
    SharedPreferences pred = await SharedPreferences.getInstance();
    setState(() {
      name = pred.getString("name");
      email = pred.getString("email");
      username = pred.getString("username");
    });
  }

  List patientData = [];
  Future<List> getUserData() async {
    try {
      var res = await http.post(Uri.parse(myurl), body: {"request": "FETCH "});

      setState(() {
        patientData = jsonDecode(res.body);
      });
    } catch (e) {
      print(e);
    }
    return patientData;
  }

  @override
  void initState() {
    super.initState();
    profile();
    getUserData();
  }

  void _Connectivity() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Row(
            children: <Widget>[
              new Icon(Icons.cancel, size: 30.0, color: Colors.deepOrange[200]),
              SizedBox(
                width: 20.0,
              ),
              new Text("No Internet Connection!"),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 245, 244, 244),
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
                  "View Bids",
                  style: TextStyle(fontSize: 17),
                ),
              ],
            )),
        body: patientData.isEmpty
            ? ShowSkelaton()
            : SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: kWhite,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 350,
                                child: Image.network(
                                  "$imgUrl/images/${patientData[0]['images']}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                color: kWhiteSmoke,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    Text(
                                      "${patientData[0]['product_name']}",
                                      style: TextStyle(
                                          fontFamily: "Bold", fontSize: 20),
                                    ),
                                    Text(
                                      "(${patientData[0]['status']})",
                                      style: TextStyle(
                                          fontFamily: "Regular", fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: kWhite,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${patientData[0]['description']}",
                              style:
                                  TextStyle(fontFamily: "Medium", fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: kWhite,
                        width: MediaQuery.of(context).size.width,
                        // height: 110,
                        child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Minimum amount"),
                                          Container(
                                            child: Text(
                                              "NGN${patientData[0]['amount']}",
                                              style: TextStyle(
                                                  fontFamily: "Medium",
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Ending Date",
                                            style: TextStyle(
                                                fontFamily: "Medium",
                                                fontSize: 16),
                                          ),
                                          Text(
                                              "${patientData[0]['ending_date']}"),
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Seller"),
                                          Text(
                                            "${patientData[0]['name']}",
                                            style: TextStyle(
                                                fontFamily: "Medium",
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Posted date"),
                                          Text(
                                            "${patientData[0]['dates']}",
                                            style: TextStyle(
                                                fontFamily: "Medium",
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      // SubHeader(
                      //   title: "My Profile",
                      //   icon: Icons.person_add_alt_1_outlined,
                      // ),
                      // sizedBox,
                      Container(
                        color: kWhite,
                        width: MediaQuery.of(context).size.width,
                        // height: 75,
                        child: Center(
                          child: Form(
                            key: _formKey,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(children: [
                                      Inputs(
                                        validator: (value) {
                                          if (value.isEmpty)
                                            return "Amount is required";
                                        },
                                        controller: amount,
                                        hint: "Amount Password",
                                        icon: Icon(Icons.attach_money),
                                        obsecure: false,
                                        keyboardType: TextInputType.number,
                                      ),
                                      sizedBox,
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: DefaultButton(
                                          color: kDefault,
                                          textColor: kWhite,
                                          title: "payment_platform",
                                          icon: Icons.person_pin_outlined,
                                          pressed: () => register(),
                                        ),
                                      ),
                                      sizedBox,
                                    ]),
                                  )
                                ]),
                          ),
                        ),
                      ),
                      sizedBox,
                    ])),
              ));
  }
}
