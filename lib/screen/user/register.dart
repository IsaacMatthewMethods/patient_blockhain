import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:patient_blockhain/component/dropdown.dart';
import 'package:patient_blockhain/component/inputs.dart';
import 'package:patient_blockhain/component/button.dart';
import 'package:patient_blockhain/constant/constant.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({super.key});

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final List<String> genderList = ['Select', 'Male', 'Female', 'Other'];
  final List<String> roleList = ['Customer', 'Artist'];

  String? selectedGender = 'Select';
  String? selectedRole = 'Customer';

  final TextEditingController fullName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<void> register() async {
    ToastContext().init(context);

    if (_formKey.currentState!.validate()) {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        _showNoConnection();
        return;
      }

      setState(() => isLoading = true);
      _showDialog();

      final response = await http.post(
        Uri.parse(myurl),
        body: {
          "request": "USER_HENNA_REGISTER",
          "full_name": fullName.text,
          "email": email.text,
          "username": username.text,
          "gender": selectedGender,
          "address": address.text,
          "password": password.text,
          "role": selectedRole,
        },
      );

      Navigator.of(context).pop(); // Close loading dialog
      setState(() => isLoading = false);

      final data = jsonDecode(response.body);

      if (data['error'] != null) {
        warningAlert(context, "Account already exists.");
        Toast.show(
          "User already registered",
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
        );
      } else if (data['success'] != null) {
        successAlert(context, "Registration successful!");
        Toast.show(
          "Welcome to Henna Hub!",
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
        );
        _clearFields();
      } else {
        Toast.show(
          "Unexpected error occurred.",
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
        );
      }
    }
  }

  void _clearFields() {
    fullName.clear();
    email.clear();
    username.clear();
    address.clear();
    password.clear();
    setState(() {
      selectedGender = 'Select';
      selectedRole = 'Customer';
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Registering..."),
          ],
        ),
      ),
    );
  }

  void _showNoConnection() {
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.redAccent),
            SizedBox(width: 20),
            Text("No Internet Connection"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: kDefault),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Henna Hub",
          style: TextStyle(color: kDefault, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              sizedBox,
              const Text(
                "Create Your Account",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Join Henna Hub as a customer or beauty artist.",
                style: TextStyle(fontSize: 14),
              ),
              sizedBox,

              // Input fields
              Inputs(
                icon: const Icon(Icons.person),
                hint: "Full Name",
                controller: fullName,
                keyboardType: TextInputType.name,
                obsecure: false,
                validator: (val) =>
                    val.isEmpty ? "Full name is required" : null,
              ),
              sizedBox,
              Inputs(
                icon: const Icon(Icons.email_outlined),
                hint: "Email Address",
                controller: email,
                keyboardType: TextInputType.emailAddress,
                obsecure: false,
                validator: (val) =>
                    val.contains("@") ? null : "Enter a valid email",
              ),
              sizedBox,
              Inputs(
                icon: const Icon(Icons.person_pin),
                hint: "Username",
                controller: username,
                keyboardType: TextInputType.text,
                obsecure: false,
                validator: (val) => val.isEmpty ? "Username required" : null,
              ),
              sizedBox,
              Inputs(
                icon: const Icon(Icons.location_on),
                hint: "Address",
                controller: address,
                keyboardType: TextInputType.streetAddress,
                obsecure: false,
                validator: (val) => val.isEmpty ? "Address required" : null,
              ),
              sizedBox,
              Inputs(
                icon: const Icon(Icons.lock_outline),
                hint: "Password",
                controller: password,
                obsecure: true,
                keyboardType: TextInputType.visiblePassword,
                validator: (val) =>
                    val.length < 6 ? "Minimum 6 characters" : null,
              ),
              sizedBox,

              // Gender and Role Dropdowns
              Row(
                children: [
                  Expanded(
                    child: MyDropDown(
                      items: genderList,
                      selectedItem: selectedGender,
                      onChange: (value) =>
                          setState(() => selectedGender = value!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: MyDropDown(
                      items: roleList,
                      selectedItem: selectedRole,
                      onChange: (value) =>
                          setState(() => selectedRole = value!),
                    ),
                  ),
                ],
              ),
              sizedBox,

              // Register Button
              DefaultButton(
                title: "Register",
                color: kDefault,
                textColor: kWhite,
                icon: Icons.app_registration,
                pressed: register,
              ),
              sizedBox,

              // Login Redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Login", style: TextStyle(color: kBlue)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
