import 'package:flutter/material.dart';

import '../constant/constant.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
        backgroundColor: kWhite,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              sizedBox,

              SizedBox(height: 100),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 180,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "img/bg3.gif",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Cultural Traditional shopping App",
                      style: TextStyle(fontSize: 18, fontFamily: "Extra"),
                    ),
                    sizedBox,
                    sizedBox,
                    CircularProgressIndicator(
                      // backgroundColor: kDefault,
                      color: kDefault,
                      strokeWidth: 2.0,
                    ),
                    sizedBox,
                    Text(
                      "Please wait...",
                      style: TextStyle(),
                    ),
                  ],
                ),
              ),
              // sizedBox,
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Alright Reserved",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
