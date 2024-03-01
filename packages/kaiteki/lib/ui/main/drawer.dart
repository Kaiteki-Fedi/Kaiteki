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

    final listsAvailable = adapter is ListSupport;
    final bookmarksAvailable = adapter is BookmarkSupport;

    const divider = Divider(
      indent: 28,
      endIndent: 28,
    );

    return NavigationDrawer(
      selectedIndex: null,
      onDestinationSelected: (i) {
        if (i >= 7 && !feedbackEnabled) i++;
        if (i >= 1 && !bookmarksAvailable) i++;
        if (i >= 2 && !listsAvailable) i++;

        Scaffold.of(context).closeDrawer();

        switch (i) {
          case 0:
            context.pushNamed(
              "bookmarks",
              pathParameters: ref.accountRouterParams,
            );
          case 1:
            context.pushNamed(
              "lists",
              pathParameters: ref.accountRouterParams,
            );
            break;
          case 3:
            // context.pushNamed(
            //   "moderation",
            //   pathParameters: ref.accountRouterParams,
            // );
            break;
          case 5:
            context.pushNamed(
              "accountSettings",
              pathParameters: ref.accountRouterParams,
            );
            break;

          case 6:
            context.push("/settings");
            break;

          case 7:
            context.push("/send-feedback");
            break;

          case 8:
            showKeyboardShortcuts(context);
            break;

          case 9:
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
        if (adapter is BookmarkSupport)
          NavigationDrawerDestination(
            icon: const Icon(Icons.bookmarks_rounded),
            label: Text(l10n.bookmarksTab),
          ),
        if (adapter is ListSupport)
          NavigationDrawerDestination(
            icon: const Icon(Icons.article_rounded),
            label: Text(l10n.listsTitle),
          ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.mail_rounded),
          label: Text(l10n.directMessagesTitle),
          enabled: false,
        ),
        divider,
        DrawerHeadline(
          text: Text(account.key.host),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.admin_panel_settings_rounded),
          label: Text("Moderation"),
          enabled: false,
        ),
        divider,
        DrawerHeadline(
          text: Text("@${account.key.username}"),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.flag_rounded),
          label: Text(l10n.reportsTitle),
          enabled: false,
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
