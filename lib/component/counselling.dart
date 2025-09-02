import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constant/constant.dart';

class CounsellingContainer extends StatelessWidget {
  final title, onPressed, date, subtitle, onTap, counsel, rank;

  final url;
  const CounsellingContainer({
    Key? key,
    this.title,
    this.onPressed,
    this.subtitle,
    required this.url,
    this.onTap,
    this.date,
    this.counsel,
    this.rank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
        child: InkWell(
            onTap: onTap,
            child: Container(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height / 2.2,
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: kWhiteSmoke),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: Offset(3, 2),
                    blurRadius: 2,
                    spreadRadius: 3,
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(url),
                            radius: 35,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title,
                                    style: TextStyle(
                                        fontFamily: "PTsans", fontSize: 20.0)),
                                Text(
                                  '${subtitle}',
                                  style: TextStyle(color: kRed),
                                ),
                                Text(
                                  '${rank}',
                                  style: TextStyle(color: kRed),
                                )
                              ],
                            ),
                          ),
                          //     Container(
                          //           width: 50,
                          //           height: 50,
                          //           decoration: BoxDecoration(
                          //             color: Colors.purple,
                          //             borderRadius: BorderRadius.circular(50),
                          //             border: Border.all(width: 1, color: kWhiteSmoke),
                          //           ),
                          //           child: Center(
                          //               child: )),
                          //   ],
                          // ),
                          //   ),
                        ]),
                    Divider(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.height / 3.5,
                      color: kWhiteSmoke,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              child: Row(
                                children: [
                                  Text(
                                    "Rank: ",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "$rank",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            // ReadMoreText(counsel.toString(),
                            //     trimCollapsedText: "Read more",
                            //     lessStyle: TextStyle(color: Colors.blue),
                            //     moreStyle: TextStyle(color: Colors.blue),
                            //     postDataTextStyle: TextStyle(
                            //       color: Colors.red,
                            //     )),
                            // SizedBox(
                            //   height: 30,
                            // ),
                            Text(
                              "Posted date: $date",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
