import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constant/constant.dart';

class Coun_App extends StatelessWidget {
  final String txt;
  const Coun_App({
    super.key,
    required this.txt,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "Auction System",
        style:
            TextStyle(fontSize: 20, color: kWhite, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        txt,
        style: TextStyle(color: kWhiteSmoke, fontSize: 15),
      ),
      // trailing: CircleAvatar(
      //   backgroundImage: NetworkImage(image.toString()),
      //   radius: 40,
      // ),
    );
  }
}
