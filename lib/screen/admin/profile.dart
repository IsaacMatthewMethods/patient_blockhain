import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../component/defaultAppBar.dart';
import '../../component/myContainer.dart';
import '../../component/skelaton.dart';
import '../../component/subHead.dart';
import '../../constant/constant.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var name, email, username;
  profile() async {
    SharedPreferences pred = await SharedPreferences.getInstance();
    setState(() {
      name = pred.getString("name");
      email = pred.getString("email");
      username = pred.getString("username");
    });
  }

  @override
  void initState() {
    super.initState();
    profile();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey.shade100, // soft background
    appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(
        name ?? 'Loading...',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 18,
          fontFamily: "SFPro", // Optional: use SF Pro if added
        ),
      ),
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Row(
              children: const [
                Icon(Icons.person, size: 24, color: Colors.black87),
                SizedBox(width: 8),
                Text(
                  "My Profile",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontFamily: "SFPro",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (name == null)
              Expanded(child: ShowSkelaton())
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey.shade300,
                        child: Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "$name",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "SFPro",
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "(Administrator)",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                          fontFamily: "SFPro",
                        ),
                      ),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Personal Information",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontFamily: "SFPro",
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Info tiles
                      AppleInfoTile(
                        title: name,
                        subtitle: "Administrator name",
                        icon: Icons.person_outline,
                      ),
                      AppleInfoTile(
                        title: email ?? "",
                        subtitle: "Email address",
                        icon: Icons.email_outlined,
                      ),
                      AppleInfoTile(
                        title: "Log Out",
                        subtitle: "Login as $name",
                        icon: Icons.logout,
                        iconColor: Colors.redAccent,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
}
class AppleInfoTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const AppleInfoTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor = Colors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: "SFPro",
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontFamily: "SFPro",
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
