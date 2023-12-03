import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/settings/locale_list_tile.dart";
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/ui/settings/settings_section.dart";

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SingleChildScrollView(
        child: SettingsContainer(
          child: Column(
            children: [
              SettingsSection(
                children: [
                  const LocaleListTile(),
                  ListTile(
                    leading: const Icon(Icons.palette_rounded),
                    title: Text(l10n.settingsCustomization),
                    onTap: () => context.push("/settings/customization"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.auto_awesome_rounded),
                    title: Text("Smart features"),
                    onTap: () => context.push("/settings/smart-features"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.tab_rounded),
                    title: Text(l10n.settingsTabs),
                    enabled: false,
                  ),
                  ListTile(
                    leading: const Icon(Icons.favorite_rounded),
                    title: Text(context.l10n.settingsWellbeing),
                    onTap: () => context.push("/settings/wellbeing"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.accessibility_new_rounded),
                    title: Text(context.l10n.settingsAccessibility),
                    onTap: () => context.push("/settings/accessibility"),
                  ),
                ],
              ),
              SettingsSection(
                title: const Text("Advanced"),
                children: [
                  ListTile(
                    onTap: () => context.push("/settings/tweaks"),
                    leading: const Icon(Icons.tune_rounded),
                    title: Text(context.l10n.settingsTweaks),
                  ),
                  ListTile(
                    leading: const Icon(Icons.science_rounded),
                    title: Text(context.l10n.settingsExperiments),
                    subtitle:
                        const Text("Try out experimental Kaiteki features!"),
                    onTap: () => context.pushNamed("experiments"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.bug_report_rounded),
                    title: Text(l10n.settingsDebugMaintenance),
                    onTap: () => context.push("/settings/debug"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
