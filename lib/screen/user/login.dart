import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_blockhain/constant/constant.dart';
import 'package:patient_blockhain/screen/user/register.dart';
import 'package:patient_blockhain/screen/user/user.nav.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool isLoading = false;

  login() async {
    ToastContext().init(context);

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      isLoading
          ? loadingAlert(context)
          : Navigator.of(context, rootNavigator: true).pop('dialog');

      final res = await http.post(
        Uri.parse(myurl),
        body: {
          "request": "ADMIN LOGIN",
          "username": username.text,
          "password": password.text,
        },
      );

      List data = jsonDecode(res.body);
      if (data.isEmpty) {
        setState(() {
          isLoading = false;
        });
        !isLoading
            ? Navigator.of(context, rootNavigator: true).pop('dialog')
            : loadingAlert(context);
        Toast.show(
          "Incorrect login Details",
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
        );
        password.clear();
      } else {
        if (res.statusCode == 200) {
          SharedPreferences pred = await SharedPreferences.getInstance();

          Navigator.of(context, rootNavigator: true).pop('dialog');
          Toast.show(
            "Login successfully",
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
          );

          setState(() {
            // transactionData = jsonDecode(res.body);
            // pred.setString("name", data[0]['name']);
            pred.setString("id", data[0]['id']);
            // pred.setString("email", data[0]['email']);
            pred.setString("username", data[0]['username']);
          });

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => CustomerNav()),
          );
        } else {
          Toast.show(
            "Error occured pls try again!",
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Soft background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
              ),
            ),
            const Text(
              "Patient Login",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  "img/patient_header.png",
                  height: 120,
                ), // ✅ Replace with your asset path
                const SizedBox(height: 24),

                const Text(
                  "Welcome Back 👋",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  "Log in to access your health records securely",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 36),

                // Username field
                _InputField(
                  controller: username,
                  hintText: "Enter your username",
                  icon: Icons.person_outline,
                  validator: (v) => v!.isEmpty ? "Username is required" : null,
                ),
                const SizedBox(height: 16),

                // Password field
                _InputField(
                  controller: password,
                  hintText: "Enter your password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  validator: (v) => v!.isEmpty ? "Password is required" : null,
                ),
                const SizedBox(height: 28),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: login,
                    icon: const Icon(Icons.login_rounded, size: 20),
                    label: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Register Prompt
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final String? Function(String?)? validator;

  const _InputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black54),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
