import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/app_colors.dart';
import 'package:kaiteki/constants.dart';
import 'package:mdi/mdi.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsAbout)),
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
                        title: Text(l10n.creditsGithubRepo),
                        trailing: const Icon(Mdi.openInNew),
                        onTap: () => launchUrl(
                          context,
                          "https://github.com/Craftplacer/kaiteki",
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Mdi.license),
                        title: Text(l10n.creditsLicenses),
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
                        title: Text(l10n.creditsTitle),
                        onTap: () {
                          Navigator.of(context).pushNamed("/credits");
                        },
                        trailing: const Icon(Mdi.chevronRight),
                      ),
                      ListTile(
                        leading: const FlutterLogo(),
                        title: Text(l10n.creditsFlutter),
                        onTap: () => launchUrl(context, "https://flutter.dev"),
                        trailing: const Icon(Mdi.openInNew),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(title: Text(l10n.creditsFriends)),
                      ListTile(
                        leading: Image.asset(
                          "assets/icons/pleroma.png",
                          width: 24,
                          height: 24,
                        ),
                        title: const Text("Pleroma"),
                        subtitle: Text(l10n.creditsPleromaDescription),
                        onTap: () {
                          launchUrl(context, "https://pleroma.social/");
                        },
                        trailing: const Icon(Mdi.openInNew),
                      ),
                      ListTile(
                        leading: Image.asset(
                          "assets/icons/husky.png",
                          width: 24,
                          height: 24,
                        ),
                        title: const Text("Husky"),
                        subtitle: Text(l10n.creditsHuskyDescription),
                        onTap: () {
                          launchUrl(context, "https://husky.adol.pw/");
                        },
                        trailing: const Icon(Mdi.openInNew),
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

  Future<void> launchUrl(BuildContext context, String url) async {
    final scaffold = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      scaffold.showSnackBar(
        SnackBar(content: Text(l10n.failedToLaunchUrl)),
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
