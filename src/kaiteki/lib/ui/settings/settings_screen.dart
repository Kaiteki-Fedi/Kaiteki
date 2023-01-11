import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/services/updates.dart';
import 'package:kaiteki/ui/settings/locale_list_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const LocaleListTile(),
            ListTile(
              leading: const Icon(Icons.palette_rounded),
              title: Text(l10n.settingsCustomization),
              onTap: () => context.push("/settings/customization"),
            ),
            ListTile(
              leading: const Icon(Icons.tab_rounded),
              title: Text(l10n.settingsTabs),
              enabled: false,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.science_rounded),
              title: const Text("Experiments"),
              subtitle: const Text("Try out experimental Kaiteki features!"),
              onTap: () => context.pushNamed("experiments"),
            ),
            ListTile(
              leading: const Icon(Icons.bug_report_rounded),
              title: Text(l10n.settingsDebugMaintenance),
              onTap: () => context.push("/settings/debug"),
            ),
            const CheckForUpdatesListTile(),
          ],
        ),
      ),
    );
  }
}

class CheckForUpdatesListTile extends ConsumerWidget {
  const CheckForUpdatesListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.update_rounded),
      title: const Text("Check for updates"),
      onTap: () async {
        final scaffoldMessenger = ScaffoldMessenger.of(context);

        final controller = scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text("Checking for new updates..."),
            duration: Duration(days: 1),
          ),
        );

        final release = await ref.refresh(updateServiceProvider.future);

        controller.close();

        if (release == null) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text("No new updates found.")),
          );
        }
      },
    );
  }
}
