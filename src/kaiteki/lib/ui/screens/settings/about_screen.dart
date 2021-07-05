import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/app_colors.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/ui/widgets/separator_text.dart';
import 'package:mdi/mdi.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var messenger = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("About")),
      body: Center(
        child: SizedBox(
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
                    const Text(Constants.appName, textScaleFactor: 2),
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
                const Text(Constants.appTagline),
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
                        leading: const Icon(Mdi.github),
                        title: const Text("Github Repository"),
                        trailing: const Icon(Mdi.openInNew),
                        onTap: () => launchUrl(
                          ScaffoldMessenger.of(context),
                          "https://github.com/Craftplacer/kaiteki",
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Mdi.license),
                        title: const Text("Open Source Licenses"),
                        trailing: const Icon(Mdi.arrowRight),
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
                      const Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: SeparatorText("CREDITS"),
                      ),
                      ListTile(
                        title: const Text("Craftplacer"),
                        subtitle: const Text("Main developer"),
                        trailing: const Icon(Mdi.openInNew),
                        onTap: () => launchUrl(
                          messenger,
                          "https://github.com/Craftplacer",
                        ),
                      ),
                      ListTile(
                        title: const Text("Odyssey98"),
                        subtitle: const Text("Icon design"),
                        trailing: const Icon(Mdi.openInNew),
                        onTap: () => launchUrl(
                          messenger,
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
                      const Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: SeparatorText("<3"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Made with "),
                            SizedBox(
                              width: 85,
                              child: InkWell(
                                onTap: () => launchUrl(
                                  messenger,
                                  "https://flutter.dev",
                                ),
                                child: FlutterLogo(
                                  style: FlutterLogoStyle.horizontal,
                                  textColor: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                            ),
                            const Text(" and love"),
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

  Future<void> launchUrl(ScaffoldMessengerState scaffold, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      scaffold.showSnackBar(
        const SnackBar(content: Text("URL couldn't be opened.")),
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
    required this.text,
    required this.color,
    required this.textColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        text,
        style: GoogleFonts.robotoMono(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
        textScaleFactor: 1.5,
      ),
    );
  }
}
