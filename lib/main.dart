import 'package:patient_blockhain/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient_blockhain/screen/user/login.dart';
import 'package:patient_blockhain/screen/user/register.dart';

import 'screen/patient_registartion.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'patient_blockhain App',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Regular"),
      routes: {
        '/': (context) => const WelcomePage(),
        '/login': (context) => const UserLogin(), // implement later
        '/signup': (context) =>
            const PatientRegistrationPage(), // implement later
      },
      // home:  WelcomePage(),
    );
  }
}
