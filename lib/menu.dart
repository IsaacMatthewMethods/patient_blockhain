import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Apple-style soft gray
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo or Icon (can replace with your own)
                const CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.black,
                  child: Icon(
                    Icons.local_hospital_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),

                // App Title
                Text(
                  "Patient Data Vault",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    letterSpacing: 1.1,
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  "Secure your health data. Powered by blockchain.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),

                const SizedBox(height: 40),

                // Patient Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/login',
                    ); // Or route to Patient page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    "Continue as Staff",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Staff Button
              ],
            ),
          ),
        ),
      ),
    );
  }
}
