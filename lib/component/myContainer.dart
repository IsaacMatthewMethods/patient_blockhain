// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../constant/constant.dart';

class MyContainer extends StatelessWidget {
  final String, head1, btn_text, head2, onpress;
  final icons, color, iconColor;
  const MyContainer(
      {Key? key,
      this.btn_text,
      this.onpress,
      this.String,
      this.head1,
      this.head2,
      this.icons,
      this.color,
      this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height / 8,
      // ignore: sort_child_properties_last
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(width: 10.0),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: iconColor,
                      borderRadius: BorderRadius.circular(40)),
                  child: Icon(
                    icons,
                    color: color,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(
                    //   height: 30.0,
                    // ),
                    Text(
                      head1,
                      style:
                          TextStyle(fontFamily: "MontSemiBold", fontSize: 18),
                    ),
                    Text(
                      head2,
                      style: TextStyle(
                          fontFamily: "MontSemiBold",
                          fontSize: 14,
                          color: kRed),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            offset: Offset(3, 2),
            blurRadius: 4,
            spreadRadius: 5,
          )
        ],
        borderRadius: BorderRadius.circular(15),
        color: kWhite,
      ),
    );
  }
}
