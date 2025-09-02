import 'package:flutter/material.dart';
import 'package:patient_blockhain/component/double_click_close.dart';
import '../../constant/constant.dart';

class AdminNav extends StatefulWidget {
  const AdminNav({Key? key}) : super(key: key);

  @override
  State<AdminNav> createState() => _AdminNavState();
}

class _AdminNavState extends State<AdminNav> {
  int _selectedIndex = 0;

  final _pageOptions = [
    // DoubleClick(child: AdminDashboard()),
    // DoubleClick(child: ManageUsersPage()),
    // DoubleClick(child: ManageTailorsPage()),
    // DoubleClick(child: AdminProfilePage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        elevation: 0.0,
        unselectedItemColor: kBlack,
        unselectedFontSize: 8.0,
        selectedFontSize: 8.0,
        showUnselectedLabels: true,
        unselectedLabelStyle: TextStyle(height: 2.5),
        selectedItemColor: kRed,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_customize),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Users"),
          BottomNavigationBarItem(
            icon: Icon(Icons.design_services),
            label: "Tailors",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
