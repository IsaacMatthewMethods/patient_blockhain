import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';

final kDefault = Color.fromARGB(255, 209, 113, 10);
final kWhite = Colors.white;
final kSmoke = Color.fromARGB(255, 204, 212, 208);
final kLightGrey = Color.fromARGB(255, 204, 212, 208);
final kRed = Color.fromARGB(255, 209, 113, 10);
final kBlue = Color.fromARGB(255, 33, 101, 1);
final green = Color.fromARGB(255, 2, 70, 37);
final sizedBox = SizedBox(
  height: 15.0,
);

final kWhiteSmoke = Color.fromARGB(255, 243, 235, 235);
final styles = TextStyle(color: kWhite, fontWeight: FontWeight.bold);
final kBlack = Colors.black;
final spaceBetween = MainAxisAlignment.spaceBetween;
final spaceAround = MainAxisAlignment.spaceAround;
final spaceEvenly = MainAxisAlignment.spaceEvenly;

// String myurl = "http://192.168.175.123/2024Apps/foodordering/index.php";

String myurl = "https://aksoft.com.ng/flutterApps2025/sewing/index.php";
// String myurl = "https://aksoft.com.ng/flutter_apps/payment_platform/index.php";
// String imgUrl = "http://192.168.175.123/2024Apps/foodordering/images/";
String imgUrl = "https://aksoft.com.ng/flutterApps2025/sewing/";
String henna = "https://aksoft.com.ng/flutterApps2025/henna/";

void successAlert(context, title) {
  CoolAlert.show(
      context: context,
      backgroundColor: Colors.green,
      type: CoolAlertType.success,
      text: title);
}

void warningAlert(context, title) {
  CoolAlert.show(
      context: context,
      backgroundColor: Colors.deepOrangeAccent,
      type: CoolAlertType.warning,
      text: title);
}

void loadingAlert(context) {
  CoolAlert.show(
      barrierDismissible: false,
      context: context,
      type: CoolAlertType.loading,
      text: "Loading...");
}
