import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/app_colors.dart';
import 'package:kaiteki/constants.dart';
import 'package:mdi/mdi.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var messenger = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("About Kaiteki")),
      body: Center(
        child: SizedBox(
          width: Constants.defaultFormWidth,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icon.png",
                  width: 128,
                  height: 128,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Constants.appName,
                      textScaleFactor: 2,
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppNameBadge(
                        color: kReleaseMode
                            ? AppColors.kaitekiPink
                            : Colors.red.shade900,
                        textColor: Colors.white,
                        text: kReleaseMode ? "ALPHA" : "DEBUG",
                      ),
                    ),
                  ],
                ),
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
                        title: const Text("GitHub Repository"),
                        trailing: const Icon(Mdi.openInNew),
                        onTap: () => launchUrl(
                          ScaffoldMessenger.of(context),
                          "https://github.com/Craftplacer/kaiteki",
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Mdi.license),
                        title: const Text("Open Source Licenses"),
                        trailing: const Icon(Mdi.chevronRight),
                        onTap: () {
                          showLicensePage(
                            context: context,
                            applicationName: Constants.appName,
                            applicationVersion: "1.0.0",
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Mdi.accountMultiple),
                        title: const Text("Credits"),
                        onTap: () {
                          Navigator.of(context).pushNamed("/credits");
                        },
                        trailing: const Icon(Mdi.chevronRight),
                      ),
                      ListTile(
                        leading: const FlutterLogo(),
                        title: const Text("Made with Flutter"),
                        onTap: () {
                          launchUrl(messenger, "https://flutter.dev");
                        },
                        trailing: const Icon(Mdi.openInNew),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      const Text("Visit our friends"),
                      ListTile(
                        leading: Image.asset(
                          "assets/icons/pleroma.png",
                          width: 24,
                          height: 24,
                        ),
                        title: const Text("Pleroma"),
                        subtitle: Text(
                          "Free and open communication for everyone.",
                        ),
                      ),
                      ListTile(
                        leading: Image.asset(
                          "assets/icons/husky.png",
                          width: 24,
                          height: 24,
                        ),
                        title: const Text("Husky"),
                        subtitle: Text("Fork of Tusky for Pleroma"),
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
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
