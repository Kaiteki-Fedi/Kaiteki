import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:kaiteki/app.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/platform_checks.dart";
import "package:kaiteki/theming/text_theme.dart";
import "package:kaiteki/ui/settings/about/app_badge_kind.dart";
import "package:kaiteki/ui/shared/layout/dfp.dart";
import "package:mdi/mdi.dart";
import "package:url_launcher/url_launcher_string.dart";

import "app_name_badge.dart";

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final badge = getBadgeKind();
    const version = KaitekiApp.versionName;

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
                  width: kFormWidth,
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
                            kAppName,
                            style: theme.textTheme.titleLarge!.merge(
                              theme.ktkTextTheme?.kaitekiTextStyle ??
                                  DefaultKaitekiTextTheme(context)
                                      .kaitekiTextStyle,
                            ),
                          ),
                          if (badge != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AppNameBadge(badge),
                            ),
                        ],
                        // kDebugMode
                      ),
                      if (version != null) ...[
                        const SizedBox(height: 8.0),
                        Text(
                          // ignore: l10n
                          "Version $version",
                          style: theme.textTheme.labelMedium,
                        ),
                      ],
                      TextButton(
                        child: Text(l10n.creditsLicenses),
                        onPressed: () => _onShowLicenses(context),
                      ),
                      const SizedBox(height: 12.0),
                      IconTheme(
                        data: IconThemeData(
                          color: theme.disabledColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.public_rounded),
                              tooltip: l10n.creditsWebsite,
                              onPressed: () => launchUrlString(kAppWebsite),
                              splashRadius: kSplashRadius,
                            ),
                            IconButton(
                              icon: const Icon(Mdi.github),
                              tooltip: l10n.creditsGithubRepo,
                              onPressed: () =>
                                  launchUrlString(kGithubRepository),
                              splashRadius: kSplashRadius,
                            ),
                            IconButton(
                              icon: const Icon(Mdi.telegram),
                              tooltip: l10n.creditsTelegramChannel,
                              onPressed: () =>
                                  launchUrlString(kTelegramChannel),
                              splashRadius: kSplashRadius,
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

  void _onShowLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: kAppName,
      // ignore: avoid_redundant_argument_values
      applicationVersion: KaitekiApp.versionName,
      applicationLegalese: kAppLegalese,
    );
  }

  AppBadgeKind? getBadgeKind() {
    if (kBuildFlavor == "BETA") return AppBadgeKind.beta;

    if (kDebugMode) {
      return AppBadgeKind.debug;
    }

    return AppBadgeKind.alpha;
  }
}
