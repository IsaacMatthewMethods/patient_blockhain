import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constant/constant.dart';

class SubHeader extends StatelessWidget {
  final title, icon;
  const SubHeader({Key? key, this.title, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: kWhiteSmoke,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: Offset(3, 2),
              blurRadius: 2,
              spreadRadius: 2,
            ),
          ]),
      height: 80,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  icon,
                  size: 30,
                )),
            SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
