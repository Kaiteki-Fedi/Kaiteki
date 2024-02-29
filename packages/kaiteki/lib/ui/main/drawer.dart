import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/constants.dart" show kAppName;
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_experiment.dart";
import "package:kaiteki/ui/main/main_screen.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";

class MainScreenDrawer extends ConsumerWidget {
  const MainScreenDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final account = ref.watch(currentAccountProvider)!;
    final adapter = ref.watch(adapterProvider);
    final feedbackEnabled = ref.watch(AppExperiment.feedback.provider);

    const divider = Divider(
      indent: 28,
      endIndent: 28,
    );

    return NavigationDrawer(
      selectedIndex: null,
      onDestinationSelected: (i) {
        if (i >= 5 && !feedbackEnabled) i++;

        switch (i) {
          case 1:
            context.pushNamed(
              "lists",
              pathParameters: ref.accountRouterParams,
            );
            break;
          case 3:
            context.pushNamed(
              "accountSettings",
              pathParameters: ref.accountRouterParams,
            );
            break;

          case 4:
            context.push("/settings");
            break;

          case 5:
            context.push("/send-feedback");
            break;

          case 6:
            showKeyboardShortcuts(context);
            break;

          case 7:
            context.push("/about");
            break;

          default:
            assert(false, "Unhandled drawer destination");
        }
      },
      children: [
        const DrawerHeadline(
          text: Text(kAppName),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.mail_rounded),
          label: Text(l10n.directMessagesTitle),
          enabled: false,
        ),
        if (adapter is ListSupport)
          NavigationDrawerDestination(
            icon: const Icon(Icons.article_rounded),
            label: Text(l10n.listsTitle),
          ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.flag_rounded),
          label: Text(l10n.reportsTitle),
          enabled: false,
        ),
        divider,
        DrawerHeadline(
          text: Text(account.key.handle.toString()),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.manage_accounts_rounded),
          label: Text(l10n.accountSettingsTitle),
        ),
        divider,
        NavigationDrawerDestination(
          icon: const Icon(Icons.settings_rounded),
          label: Text(l10n.settings),
        ),
        if (feedbackEnabled)
          const NavigationDrawerDestination(
            icon: Icon(Icons.feedback_rounded),
            label: Text("Send Feedback"),
          ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.keyboard_rounded),
          label: Text(l10n.keyboardShortcuts),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.info_rounded),
          label: Text(l10n.settingsAbout),
        ),
      ],
    );
  }
}
