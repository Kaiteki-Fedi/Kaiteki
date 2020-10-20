import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/constants.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About")
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getRandomEmoticon(),
                    textScaleFactor: 5,
                  ),
                  Text(
                    Constants.appName,
                    textScaleFactor: 2,
                  ),
                  Text(
                    "< ALPHA >",
                    style: GoogleFonts.robotoMono(
                      color: Colors.pinkAccent,
                      fontWeight: FontWeight.bold
                    ),
                    textScaleFactor: 1.5,
                  ),
                  Text(Constants.appTagline)
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                child: Text("Licenses"),
                onPressed: () => showLicensePage(
                    context: context,
                    applicationName: Constants.appName,
                    applicationVersion: "1.0.0"
                ),
              ),
              FlatButton(
                child: Text("GitHub"),
                onPressed: () {

                },
              ),
            ],
          )
        ],
      ),
    );
  }

  String getRandomEmoticon() {
    const List<String> emoticons = <String>[
      "=w=",
      ":3",
      "~w~",
      ">w<",
      "owo",
      "uwu",
      "(´o w o`)",
      "(｡♥‿♥｡)",
      "(*^‿^*)"
    ];

    var index = Random().nextInt(emoticons.length);

    return emoticons[index];
  }
}


