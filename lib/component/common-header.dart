import 'package:flutter/material.dart';

import '../constant/constant.dart';
// import 'constant/constant.dart';

class CommonHeader extends StatelessWidget {
  final title;
  const CommonHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
            top: 40.0, left: 15.0, bottom: 10, right: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$title",
              style: TextStyle(color: kBlack, fontSize: 25),
            ),
            Row(
              children: [
                Text(
                  "Shipping to: ",
                  style: TextStyle(fontSize: 12, fontFamily: "Regular"),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: kWhiteSmoke),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text("Nigeria",
                        style: TextStyle(fontSize: 12, fontFamily: "Bold")),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                // Icon(Icons.camera_enhance_outlined),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Icon(Icons.shopping_cart_outlined),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 13.0),
                        child: Container(
                          child: Center(
                              child: Text(
                            "1",
                            style: TextStyle(
                                color: kWhite,
                                fontSize: 12,
                                fontFamily: "Regular"),
                          )),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 8, 2, 2)
                                      .withOpacity(0.2),
                                  offset: Offset(1, 1),
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                )
                              ],
                              color: kRed,
                              borderRadius: BorderRadius.circular(25.0)),
                          width: 18,
                          height: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
