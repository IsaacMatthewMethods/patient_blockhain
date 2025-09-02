import 'package:flutter/material.dart';
import 'package:patient_blockhain/component/double_click_close.dart';
import 'package:patient_blockhain/screen/user/dashboard.dart'; // Home screen
import 'package:patient_blockhain/screen/user/profile.dart'; // Profile screen
import '../../constant/constant.dart';
import '../patient_registartion.dart';

class CustomerNav extends StatefulWidget {
  const CustomerNav({Key? key}) : super(key: key);

  @override
  State<CustomerNav> createState() => _CustomerNavState();
}

class _CustomerNavState extends State<CustomerNav> {
  int _selectedIndex = 0;

  final _pageOptions = [
    DoubleClick(child: ManagementDashboard()), // Home
    DoubleClick(child: PatientRegistrationPage()), // Browse Shops
    DoubleClick(child: Profile()), // Profile
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
        unselectedLabelStyle: const TextStyle(height: 2.5),
        selectedItemColor: kRed,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            label: "Patients",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
