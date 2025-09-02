import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constant/constant.dart';

class Input extends StatelessWidget {
  final controller, keyboardType, text, color, validator;
  final bool obscure;
  final Icon icon;
  const Input(
      {Key? key,
      required this.obscure,
      required this.icon,
      this.controller,
      this.keyboardType,
      this.text,
      this.validator,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(25)),
      child: TextFormField(
        cursorColor: kRed,
        keyboardType: keyboardType,
        controller: controller,
        validator: validator,
        obscureText: obscure,
        decoration: InputDecoration(
            hintText: text,
            icon: Icon(
              Icons.person_outline_outlined,
            ),
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            border: InputBorder.none,
            suffixIcon: icon),
      ),
    );
  }
}
