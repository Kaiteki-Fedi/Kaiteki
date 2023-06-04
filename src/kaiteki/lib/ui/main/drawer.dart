import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/constants.dart" show appName;
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_experiment.dart";
import "package:kaiteki/theming/kaiteki/text_theme.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";

class MainScreenDrawer extends ConsumerWidget {
  final VoidCallback onSwitchLayout;

  const MainScreenDrawer({super.key, required this.onSwitchLayout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final account = ref.watch(accountProvider)!;
    final fontSize = Theme.of(context).textTheme.titleLarge?.fontSize;
    final adapter = ref.watch(adapterProvider);
    final feedbackEnabled = ref.watch(AppExperiment.feedback.provider);
    final layoutsEnabled = ref.watch(AppExperiment.timelineViews.provider);

    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 16.0,
                ),
                child: Text(
                  appName,
                  style: Theme.of(context) //
                      .ktkTextTheme
                      ?.kaitekiTextStyle
                      .copyWith(fontSize: fontSize),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.mail_rounded),
                title: Text(l10n.directMessagesTitle),
                enabled: false,
              ),
              if (adapter is ListSupport)
                ListTile(
                  leading: const Icon(Icons.article_rounded),
                  title: Text(l10n.listsTitle),
                  onTap: () => context.pushNamed(
                    "lists",
                    pathParameters: ref.accountRouterParams,
                  ),
                ),
              ListTile(
                leading: const Icon(Icons.trending_up_rounded),
                title: Text(l10n.trendsTitle),
                enabled: false,
              ),
              ListTile(
                leading: const Icon(Icons.flag_rounded),
                title: Text(l10n.reportsTitle),
                enabled: false,
              ),
              const Divider(),
              ListTile(
                title: Text(
                  account.key.handle.toString(),
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                enabled: false,
              ),
              ListTile(
                leading: const Icon(Icons.manage_accounts_rounded),
                title: Text(l10n.accountSettingsTitle),
                onTap: () => context.pushNamed(
                  "accountSettings",
                  pathParameters: ref.accountRouterParams,
                ),
              ),
              if (layoutsEnabled) ...[
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.swap_horiz_rounded),
                  title: const Text("Switch Layout"),
                  onTap: onSwitchLayout,
                ),
              ],
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings_rounded),
                title: Text(l10n.settings),
                onTap: () => context.push("/settings"),
              ),
              if (feedbackEnabled)
                ListTile(
                  leading: const Icon(Icons.feedback_rounded),
                  title: const Text("Send Feedback"),
                  onTap: () => context.push("/send-feedback"),
                ),
              ListTile(
                leading: const Icon(Icons.info_rounded),
                title: Text(l10n.settingsAbout),
                onTap: () => context.push("/about"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
