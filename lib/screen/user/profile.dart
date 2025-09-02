import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../component/defaultAppBar.dart';
import '../../component/myContainer.dart';
import '../../component/skelaton.dart';
import '../../constant/constant.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String currentUserId = ''; // Default value
  String userName = 'Guest'; // Default value
  String userEmail = 'guest@example.com'; // Default value
  String userPhone = 'Hospital staff'; // Default value
  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId =
          prefs.getString("user_id") ?? '0'; // More user-friendly default
      userName =
          prefs.getString("full_name") ??
          'Administrator'; // More user-friendly default
      userEmail = prefs.getString("email") ?? 'staff@example.com';
      userPhone = prefs.getString("role") ?? 'N/A';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: kWhite,
        elevation: 0,
        title: Text(
          userName ?? "Profile",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.asset(
                "img/user.jpg",
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                Text(
                  "$userName",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: "SF Pro Display",
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "($userPhone)",
                  style: const TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Personal Info",
                    style: TextStyle(
                      fontSize: 16,
                      color: kDefault,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                /// Styled info cards
                _infoCard(
                  title: "Staff Name",
                  value: userName ?? "",
                  icon: Icons.person_outline,
                  iconColor: kDefault,
                ),
                _infoCard(
                  title: "Email Address",
                  value: userEmail ?? "",
                  icon: Icons.email_outlined,
                  iconColor: Colors.blue,
                ),
                _infoCard(
                  title: "Log out",
                  value: "Login as $userName",
                  icon: Icons.logout_outlined,
                  iconColor: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Apple-like card style
  Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.1),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
