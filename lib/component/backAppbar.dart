import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constant/constant.dart';

class BackAppBar extends StatelessWidget {
  final String name, title;
  const BackAppBar({super.key, required this.name, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style:
            TextStyle(fontSize: 20, color: kWhite, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        name,
        style: TextStyle(color: kWhiteSmoke, fontSize: 15),
      ),
      trailing: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("img/admin.jpg"), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(30),
          color: kWhite,
        ),
      ),
    );
  }
}
