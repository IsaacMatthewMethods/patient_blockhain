import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:patient_blockhain/constant/constant.dart';
import 'package:toast/toast.dart';

class PatientRegistrationPage extends StatefulWidget {
  const PatientRegistrationPage({super.key});

  @override
  State<PatientRegistrationPage> createState() =>
      _PatientRegistrationPageState();
}

class _PatientRegistrationPageState extends State<PatientRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  // Step tracking
  int _currentStep = 0;

  // Controllers for personal info
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  // Images for documents
  XFile? passportPhoto;
  XFile? otherDocument;

  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(bool isPassport) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (isPassport) {
          passportPhoto = picked;
        } else {
          otherDocument = picked;
        }
      });
    }
  }

  void showCustomToast(String message) {
    Toast.show(
      message,
      duration: Toast.lengthLong,
      gravity: Toast.bottom, // CENTER doesn't work well on older toast
      backgroundColor: Colors.red,
      textStyle: const TextStyle(color: Colors.white, fontSize: 16),
    );
  }

  Future<void> uploadDesign() async {
    ToastContext().init(context);

    if (_formKey.currentState!.validate()) {
      if (passportPhoto == null) {
        showCustomToast("Please upload your passport photo");
        return;
      }

      if (otherDocument == null) {
        showCustomToast("Please upload the required supporting document");
        return;
      }

      if (selectedBloodGroup == null) {
        showCustomToast("Please select your blood group");
        return;
      }

      if (selectedGender == null) {
        showCustomToast("Please select your gender");
        return;
      }

      if (selectedGenotype == null) {
        showCustomToast("Please select your genotype");
        return;
      }

      setState(() => isLoading = true);

      try {
        String base64Passport = base64Encode(
          await passportPhoto!.readAsBytes(),
        );
        String? base64OtherDoc;
        if (otherDocument != null) {
          base64OtherDoc = base64Encode(await otherDocument!.readAsBytes());
        }

        final uri = Uri.parse(myurl);
        final response = await http.post(
          uri,
          body: {
            "request": "PATIENT_REGISTRATION",
            'full_name': fullNameController.text.trim(),
            'email': emailController.text.trim(),
            'phone': phoneController.text.trim(),
            'passport_photo': base64Passport,
            'other_document': base64OtherDoc ?? '',
          },
        );

        final body = json.decode(response.body);

        if (body == "success") {
          Toast.show(
            "Design uploaded successfully!",
            duration: Toast.lengthLong,
          );
          _formKey.currentState!.reset();
          setState(() {
            passportPhoto = null;
            otherDocument = null;
            selectedBloodGroup = null;
            selectedGender = null;
            selectedGenotype = null;
            fullNameController.clear();
            emailController.clear();
            phoneController.clear();
          });
        } else if (body == "image_error") {
          Toast.show("Image upload failed", duration: Toast.lengthLong);
        } else if (body == "db_error") {
          Toast.show("Database error", duration: Toast.lengthLong);
        } else {
          Toast.show("Unexpected error", duration: Toast.lengthLong);
        }
      } catch (e) {
        Toast.show("Upload error: ${e.toString()}", duration: Toast.lengthLong);
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> submitRegistration() async {
    // if (_formKey.currentState == null || !_formKey.currentState!.validate())
    // return;

    if (passportPhoto == null) {
      Toast.show(
        "Please upload your passport photo",
        duration: Toast.lengthLong,
        backgroundColor: Colors.red,
        gravity: Toast.center,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Encode images to base64
      String base64Passport = base64Encode(await passportPhoto!.readAsBytes());
      String? base64OtherDoc;
      if (otherDocument != null) {
        base64OtherDoc = base64Encode(await otherDocument!.readAsBytes());
      }

      final uri = Uri.parse(myurl);
      final response = await http.post(
        uri,
        body: {
          "request": "PATIENT_REGISTRATION",
          'full_name': fullNameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'passport_photo': base64Passport,
          'other_document': base64OtherDoc ?? '',
          "gender": selectedGender ?? "Not Selected",
          "blood_group": selectedBloodGroup ?? "Not Selected",
          "genotype": selectedGenotype ?? "Not Selected",
        },
      );

      final decoded = jsonDecode(response.body);

      switch (decoded) {
        case 'success':
          Toast.show(
            "🎉 Registration successful!",
            duration: Toast.lengthLong,
            backgroundColor: Colors.green,
            gravity: Toast.center,
          );

          // Optional short delay to show the success message
          await Future.delayed(const Duration(seconds: 2));

          // Navigate to Welcome page (adjust route name or widget accordingly)
          Navigator.of(context).pop();

          break;

        case 'user_exists':
          Toast.show(
            "⚠️ User already exists with this email or phone",
            duration: Toast.lengthLong,
            backgroundColor: Colors.red,
            gravity: Toast.center,
          );
          break;

        case 'passport_upload_error':
          Toast.show(
            "❌ Failed to upload passport photo",
            duration: Toast.lengthLong,
            backgroundColor: Colors.red,
            gravity: Toast.center,
          );

          break;

        case 'other_document_upload_error':
          Toast.show(
            "❌ Failed to upload other document",
            duration: Toast.lengthLong,
            backgroundColor: Colors.red,
            gravity: Toast.center,
          );

          break;

        case 'db_error':
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🛑 Database error. Try again later.'),
            ),
          );
          break;

        default:
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Unknown response: $decoded')));
          print('Unexpected response: $decoded');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload error: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void nextStep() {
    if (_currentStep == 0) {
      // Validate personal info step
      if (_formKey.currentState!.validate()) {
        setState(() => _currentStep += 1);
      }
    } else if (_currentStep == 1) {
      // Check passport upload
      if (passportPhoto == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload your passport photo')),
        );
      } else {
        setState(() => _currentStep += 1);
      }
    }
  }

  void backStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      _personalInfoStep(),
      _documentUploadStep(),
      _confirmationStep(),
    ];

    return Scaffold(
      body: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.systemGrey6,
          middle: const Text(
            'Patient Registration',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          previousPageTitle: _currentStep > 0 ? 'Back' : null,
          leading: _currentStep > 0
              ? CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: backStep,
                  child: const Icon(CupertinoIcons.back),
                )
              : null,
        ),
        child: SafeArea(
          child: isLoading
              ? const Center(child: CupertinoActivityIndicator(radius: 15))
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      _AppleStepper(
                        totalSteps: steps.length,
                        currentStep: _currentStep,
                        stepTitles: const [
                          'Personal Info',
                          'Documents',
                          'Confirm',
                        ],
                      ),
                      const SizedBox(height: 24),
                      Expanded(child: steps[_currentStep]),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_currentStep > 0)
                            CupertinoButton.filled(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 14,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              onPressed: backStep,
                              child: const Text('Back'),
                            ),
                          CupertinoButton.filled(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 36,
                              vertical: 14,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            onPressed: isLoading
                                ? null
                                : _currentStep == steps.length - 1
                                ? submitRegistration
                                : nextStep,
                            child: _currentStep == steps.length - 1
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isLoading)
                                        const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      else
                                        const Icon(Icons.cloud_upload_outlined),
                                      const SizedBox(width: 8),
                                      Text(
                                        isLoading ? 'Uploading...' : 'Submit',
                                      ),
                                    ],
                                  )
                                : const Text('Next'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  String? selectedBloodGroup;
  String? selectedGenotype;
  String? selectedGender;

  Widget _personalInfoStep() {
    return Form(
      key: _formKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          // Full Name
          _InputField(
            controller: fullNameController,
            hintText: 'Full Name',
            icon: CupertinoIcons.person,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Full Name is required' : null,
          ),
          const SizedBox(height: 20),

          // Age
          _InputField(
            controller: ageController,
            hintText: 'Age',
            icon: CupertinoIcons.calendar,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Age is required' : null,
          ),
          const SizedBox(height: 20),

          // Email
          _InputField(
            controller: emailController,
            hintText: 'Email Address',
            icon: CupertinoIcons.mail,
            validator: (v) => (v == null || !v.contains('@'))
                ? 'Valid email is required'
                : null,
          ),
          const SizedBox(height: 20),

          // Phone
          _InputField(
            controller: phoneController,
            hintText: 'Phone Number',
            icon: CupertinoIcons.phone,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Phone number is required' : null,
          ),
          const SizedBox(height: 20),

          // Blood Group Dropdown
          _DropdownField(
            value: selectedBloodGroup,
            items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
            hintText: 'Select Blood Group',
            icon: CupertinoIcons.drop,
            onChanged: (val) => selectedBloodGroup = val,
            validator: (v) =>
                v == null || v.isEmpty ? 'Blood group is required' : null,
          ),
          const SizedBox(height: 20),

          // Genotype Dropdown
          _DropdownField(
            value: selectedGenotype,
            items: ['AA', 'AS', 'SS', 'AC', 'SC'],
            hintText: 'Select Genotype',
            icon: CupertinoIcons.heart,
            onChanged: (val) => selectedGenotype = val,
            validator: (v) =>
                v == null || v.isEmpty ? 'Genotype is required' : null,
          ),
          const SizedBox(height: 20),

          // Gender Dropdown
          _DropdownField(
            value: selectedGender,
            items: ['Male', 'Female', 'Other'],
            hintText: 'Select Gender',
            icon: CupertinoIcons.person_2,
            onChanged: (val) => selectedGender = val,
            validator: (v) =>
                v == null || v.isEmpty ? 'Gender is required' : null,
          ),
        ],
      ),
    );
  }

  Widget _documentUploadStep() {
    Widget buildUploadTile(
      String label,
      File? image,
      VoidCallback onTap,
      IconData icon,
    ) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: CupertinoColors.systemGrey3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: image == null
                  ? Center(
                      child: Icon(
                        icon,
                        size: 56,
                        color: CupertinoColors.systemGrey3,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(image, fit: BoxFit.cover),
                    ),
            ),
          ),
        ],
      );
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
        buildUploadTile(
          'Upload Other Document (Optional)',
          passportPhoto != null ? File(passportPhoto!.path) : null, // ✅ FIX
          () => pickImage(true),
          CupertinoIcons.camera_fill,
        ),

        buildUploadTile(
          'Upload Other Document (Optional)',
          otherDocument != null ? File(otherDocument!.path) : null, // ✅ FIX
          () => pickImage(false),
          CupertinoIcons.doc_fill,
        ),
      ],
    );
  }

  Widget _confirmationStep() {
    Widget infoTile(String title, String subtitle) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          Text(
            subtitle,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const Text(
          'Confirm your information',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        infoTile('Full Name', fullNameController.text),
        infoTile('Email', emailController.text),
        infoTile('Phone Number', phoneController.text),
        infoTile(
          'Passport Photo',
          passportPhoto != null ? 'Uploaded' : 'Not uploaded',
        ),
        infoTile(
          'Other Document',
          otherDocument != null ? 'Uploaded' : 'Not uploaded',
        ),
        infoTile('Age', ageController.text),
        infoTile('Gender', selectedGender ?? "Not Selected"),
        infoTile('Blood Group', selectedBloodGroup ?? "Not Selected"),
        infoTile('Genotype', selectedGenotype ?? "Not Selected"),
      ],
    );
  }
}

class _AppleStepper extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final List<String> stepTitles;

  const _AppleStepper({
    required this.totalSteps,
    required this.currentStep,
    required this.stepTitles,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        final isCompleted = index < currentStep;
        return Expanded(
          child: Column(
            children: [
              Container(
                width: isActive ? 36 : 28,
                height: isActive ? 36 : 28,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.black
                      : CupertinoColors.systemGrey4,
                  shape: BoxShape.circle,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isCompleted ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.w700,
                      fontSize: isActive ? 18 : 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                stepTitles[index],
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                  fontSize: isActive ? 14 : 12,
                  color: isActive ? Colors.black : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }),
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
    required this.controller,
    required this.hintText,
    required this.icon,
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

class _DropdownField extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String hintText;
  final IconData icon;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;

  const _DropdownField({
    required this.value,
    required this.items,
    required this.hintText,
    required this.icon,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: validator,
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
