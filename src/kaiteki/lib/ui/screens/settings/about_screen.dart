import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/app_colors.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/ui/widgets/separator_text.dart';
import 'package:mdi/mdi.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("About")),
      body: Center(
        child: Container(
          width: Constants.defaultFormWidth,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  getRandomEmoticon(),
                  textScaleFactor: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(Constants.appName, textScaleFactor: 2),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppNameBadge(
                        color: AppColors.kaitekiPink,
                        textColor: Colors.white,
                        text: "ALPHA",
                      ),
                    ),
                  ],
                ),
                Text(Constants.appTagline),
                Card(
                  margin: const EdgeInsets.only(
                    left: 4.0,
                    right: 4.0,
                    top: 24.0,
                    bottom: 4.0,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Mdi.github),
                        title: Text("Github Repository"),
                        trailing: Icon(Mdi.openInNew),
                        onTap: () => launchUrl(
                          _scaffoldKey.currentState,
                          "https://github.com/Craftplacer/kaiteki",
                        ),
                      ),
                      ListTile(
                        leading: Icon(Mdi.license),
                        title: Text("Open Source Licenses"),
                        trailing: Icon(Mdi.arrowRight),
                        onTap: () {
                          showLicensePage(
                            context: context,
                            applicationName: Constants.appName,
                            applicationVersion: "1.0.0",
                          );
                        },
                      )
                    ],
                  ),
                ),
                Card(
                  margin: const EdgeInsets.only(
                    left: 4.0,
                    right: 4.0,
                    top: 12.0,
                    bottom: 4.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: SeparatorText("CREDITS"),
                      ),
                      ListTile(
                        title: Text("Craftplacer"),
                        subtitle: Text("Main developer"),
                        trailing: Icon(Mdi.openInNew),
                        onTap: () => launchUrl(
                          _scaffoldKey.currentState,
                          "https://github.com/Craftplacer",
                        ),
                      ),
                      ListTile(
                        title: Text("Odyssey98"),
                        subtitle: Text("Icon design"),
                        trailing: Icon(Mdi.openInNew),
                        onTap: () => launchUrl(
                          _scaffoldKey.currentState,
                          "https://mstdn.social/@odyssey98",
                        ),
                      )
                    ],
                  ),
                ),
                Card(
                  margin: const EdgeInsets.only(
                    left: 4,
                    right: 4,
                    top: 12.0,
                    bottom: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: SeparatorText("<3"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Made with "),
                            SizedBox(
                              width: 85,
                              child: InkWell(
                                onTap: () => launchUrl(
                                  _scaffoldKey.currentState,
                                  "https://flutter.dev",
                                ),
                                child: FlutterLogo(
                                  style: FlutterLogoStyle.horizontal,
                                  textColor: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? null
                                      : Colors.white,
                                ),
                              ),
                            ),
                            Text(" and love"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> launchUrl(ScaffoldState scaffold, String url) async {
    if (await canLaunch(url))
      await launch(url);
    else {
      scaffold.showSnackBar(
        SnackBar(content: Text("URL couldn't be opened.")),
      );
    }
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

class AppNameBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const AppNameBadge({
    this.text,
    this.color,
    this.textColor,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        text,
        style: GoogleFonts.robotoMono(
          color: this.textColor,
          fontWeight: FontWeight.bold,
        ),
        textScaleFactor: 1.5,
      ),
    );
  }
}
