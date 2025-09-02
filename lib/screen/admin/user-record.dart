import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../../component/adminContainer.dart';
import '../../component/defaultAppBar.dart';
// import '../../component/skelaton.dart';
import '../../constant/constant.dart';

class DonorRecord extends StatefulWidget {
  final status;
  DonorRecord(this.status);

  @override
  State<DonorRecord> createState() => _DonorRecordState();
}

class _DonorRecordState extends State<DonorRecord> {
  List patientData = [];
  var id;
  int _counter = 1;
  bool isLoading = false;

  Future<void> delete(String user_id) async {
    ToastContext().init(context);

    setState(() {
      isLoading = true;
    });
    try {
      final res = await http.post(Uri.parse(myurl),
          body: {"request": "DELETE STUDENT", "id": user_id});
      setState(() {
        isLoading = false;
      });
      !isLoading ? Navigator.of(context).pop('dialog') : _showDialog();

      Toast.show("Record deleted successfully",
          duration: Toast.lengthShort, gravity: Toast.bottom);

      getUserData();
    } catch (e) {
      print(e);
    }
  }

  showAlertDialog(BuildContext context, Function pressed) {
    Widget okBtn = TextButton(
      onPressed: () {
        pressed();
        // Navigator.of(context).pop('dialog');
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => CleanerRecord()));
      },
      child: Text("Yes"),
    );

    Widget noBtn = TextButton(
      onPressed: () {
        Navigator.of(context).pop('dialog');
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => CleanerRecord()));
      },
      child: Text("No"),
    );

    AlertDialog alert = AlertDialog(
      title: Text("Status"),
      content: Text("Are you sure you want to delete?"),
      actions: [
        okBtn,
        noBtn,
      ],
    );

    //show the dialog alert
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  Future<List> getUserData() async {
    // SharedPreferences pred = await SharedPreferences.getInstance();
    try {
      var res = await http
          .post(Uri.parse(myurl), body: {"request": "FETCH ALL USERS"});

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
        centerTitle: true,
        automaticallyImplyLeading: widget.status,
        backgroundColor: kDefault,
        title: DefaultAppBar(txt: "$name"),
      ),
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
                      ? ListView.builder(
                          itemCount: patientData.length,
                          itemBuilder: (context, index) {
                            return AdminContainer(
                              icon: IconButton(
                                  onPressed: () {
                                    showAlertDialog(context, () {
                                      delete(patientData[index]['student_id']);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete_outline_outlined,
                                    size: 30,
                                    color: kRed,
                                  )),
                              // iconPressed: () {
                              //   // showAlertDialog(context);
                              // },

                              onPressed: () {
                                // showAlertDialog(context);
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) =>
                                //         Payment(transactionData[index]['id'])));
                              },
                              title: patientData[index]['name'].toUpperCase(),
                              subtitle: patientData[index]['email'],
                            );
                          })
                      : Center(child: Text("No Payment records"));
                }
              }),
        ),
      ),
    );
  }
}
