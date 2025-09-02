import 'package:flutter/material.dart';


class Inputs extends StatelessWidget {
  final hint, obsecure;
  final controller, keyboardType, text, color, validator;
  final Icon icon;
  const Inputs(
      {Key? key,
      this.hint,
      required this.icon,
      this.controller,
      this.keyboardType,
      this.text,
      this.color,
      this.validator,
      this.obsecure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: TextFormField(
                keyboardType: keyboardType,
                controller: controller,
                validator: validator,
                obscureText: obsecure,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  hintText: hint,
                  // labelText: hint,
                  border: OutlineInputBorder(),
                  prefixIcon: icon,
                )),
          )
        ],
      ),
    );
  }
}
