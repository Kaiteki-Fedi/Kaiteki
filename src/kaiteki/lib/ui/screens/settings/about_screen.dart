import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/app_colors.dart';
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/di.dart';
import 'package:kaiteki/utils/extensions/build_context.dart';
import 'package:mdi/mdi.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsAbout)),
      body: Center(
        child: SizedBox(
          width: consts.defaultFormWidth,
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
                      consts.appName,
                      textScaleFactor: 2,
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppNameBadge(
                        color: kReleaseMode ? kaitekiPink : Colors.red.shade900,
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
                        leading: const Icon(Mdi.license),
                        title: Text(l10n.creditsLicenses),
                        trailing: const Icon(Mdi.chevronRight),
                        onTap: () {
                          showLicensePage(
                            context: context,
                            applicationName: consts.appName,
                            applicationVersion: "1.0.0",
                            applicationLegalese:
                                "Licensed under the GNU Affero General Public License v3.0",
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Mdi.accountMultiple),
                        title: Text(l10n.creditsTitle),
                        onTap: () => context.push("/credits"),
                        trailing: const Icon(Mdi.chevronRight),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(title: Text(l10n.creditsFriends)),
                      ListTile(
                        leading: const FlutterLogo(),
                        title: const Text("Flutter"),
                        onTap: () => context.launchUrl("https://flutter.dev"),
                        trailing: const Icon(Mdi.openInNew),
                      ),
                      const Divider(),
                      ListTile(
                        leading: Image.asset(
                          "assets/icons/pleroma.png",
                          width: 24,
                          height: 24,
                        ),
                        title: const Text("Pleroma"),
                        subtitle: Text(l10n.creditsPleromaDescription),
                        onTap: () =>
                            context.launchUrl("https://pleroma.social/"),
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
                        onTap: () =>
                            context.launchUrl("https://husky.adol.pw/"),
                        trailing: const Icon(Mdi.openInNew),
                      ),
                    ],
                  ),
                ),
                IconTheme(
                  data: IconThemeData(
                    color: Theme.of(context).disabledColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Mdi.earth),
                        tooltip: l10n.creditsWebsite,
                        onPressed: () {
                          context.launchUrl(consts.appWebsite);
                        },
                        splashRadius: consts.defaultSplashRadius,
                      ),
                      IconButton(
                        icon: const Icon(Mdi.github),
                        tooltip: l10n.creditsGithubRepo,
                        onPressed: () {
                          context.launchUrl(consts.githubRepository);
                        },
                        splashRadius: consts.defaultSplashRadius,
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
