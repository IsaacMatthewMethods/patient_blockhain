import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constant/constant.dart';

class DefaultButton extends StatelessWidget {
  final title, pressed, color, textColor, icon;
  const DefaultButton(
      {super.key,
      this.title,
      this.pressed,
      this.color,
      this.icon,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: kDefault),
            color: color,
            borderRadius: BorderRadius.circular(10)),
        width: MediaQuery.of(context).size.width,
        height: 45,
        child: OutlinedButton(
            onPressed: pressed,
            // if (_formKey.currentState!.validate()) {
            //   Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(
            //           builder: (contex) => Navigation()));
            // }
            // login();

            style: OutlinedButton.styleFrom(side: BorderSide.none),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: textColor,
                  size: 20.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  title,
                  style: TextStyle(color: textColor, fontSize: 15),
                ),
              ],
            )));
  }
}
