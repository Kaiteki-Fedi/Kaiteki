import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/di.dart';
import 'package:kaiteki/ui/settings/about/app_badge_kind.dart';
import 'package:kaiteki/ui/shared/dfp.dart';
import 'package:kaiteki/utils/extensions/build_context.dart';
import 'package:mdi/mdi.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();
    final badge = getBadgeKind();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsAbout)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: DfpWidget(
              top: .125,
              constraints: constraints,
              child: Center(
                child: SizedBox(
                  width: consts.defaultFormWidth,
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
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (badge != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: badge.build(),
                            ),
                        ],
                        // kDebugMode
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
                              trailing: const Icon(Icons.chevron_right_rounded),
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
                              leading: const Icon(Icons.people_rounded),
                              title: Text(l10n.creditsTitle),
                              onTap: () => context.push("/credits"),
                              trailing: const Icon(Icons.chevron_right_rounded),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      IconTheme(
                        data: IconThemeData(
                          color: Theme.of(context).disabledColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.public_rounded),
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
                            IconButton(
                              icon: const Icon(Mdi.telegram),
                              tooltip: l10n.creditsTelegramChannel,
                              onPressed: () {
                                context.launchUrl(consts.telegramChannel);
                              },
                              splashRadius: consts.defaultSplashRadius,
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
        },
      ),
    );
  }

  AppBadgeKind? getBadgeKind() {
    if (kDebugMode) {
      return AppBadgeKind.debug;
    }

    return AppBadgeKind.alpha;
  }
}
