import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/settings/locale_list_tile.dart";
import "package:kaiteki/ui/settings/section_header.dart";
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
                title: const SectionHeader("Advanced"),
                children: [
                  ListTile(
                    onTap: () => context.push("/settings/pedantry"),
                    leading: const Icon(Icons.rule_rounded),
                    title: Text(context.l10n.settingsPedantry),
                    subtitle: const Text("Settings for power users"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.science_rounded),
                    title: const Text("Experiments"),
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
