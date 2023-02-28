import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/ui/settings/preference_switch_list_tile.dart";
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/ui/settings/settings_section.dart";

class PedantryScreen extends StatelessWidget {
  const PedantryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsPedantry)),
      body: SettingsContainer(
        child: Column(
          children: [
            SettingsSection(
              children: [
                PreferenceSwitchListTile(
                  provider: showReadNotifications,
                  title: const Text("Show read notifications"),
                  subtitle: const Text(
                    "The read tab will be shown by default if there are no unread notifications",
                  ),
                ),
                const SwitchListTile(
                  title: Text("Use search bar"),
                  subtitle: Text(
                    "Replaces the app bar with a search bar",
                  ),
                  onChanged: null,
                  value: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
