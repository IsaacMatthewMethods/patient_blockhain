import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';

import '../constant/constant.dart';

class DoubleClick extends StatelessWidget {
  final child;
  const DoubleClick({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: DoubleBack(
        message: "Press the back button again to exit",
        child: child,
      ),
    );
  }
}
