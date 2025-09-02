import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constant/constant.dart';

class DefaultAppBar extends StatelessWidget {
  final String txt;
  const DefaultAppBar({Key? key, required this.txt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "SEWING HUB",
        style: TextStyle(fontSize: 16, color: kWhite, fontFamily: "Bold"),
      ),
      subtitle: Text(
        txt,
        style: TextStyle(color: kWhiteSmoke, fontSize: 15),
      ),
      trailing: Container(
        decoration: BoxDecoration(
            border: Border.all(color: kWhite, width: 2.0),
            borderRadius: BorderRadius.circular(50)),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("img/admin.jpg"), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(30),
              color: kWhite,
            ),
          ),
        ),
      ),
    );
  }
}
