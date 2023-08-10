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
                  provider: useSearchBar,
                  title: const Text("Use search bar"),
                  subtitle: const Text(
                    "Replaces the app bar with a search bar",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
