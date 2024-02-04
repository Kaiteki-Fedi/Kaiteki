import "package:flutter/material.dart";
import "package:kaiteki/preferences/app_preferences.dart" as preferences;
import "package:kaiteki/ui/settings/locale_list_tile.dart";
import "package:kaiteki/ui/settings/preference_switch_list_tile.dart";
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/ui/settings/settings_section.dart";

class GeneralSettingsScreen extends StatelessWidget {
  const GeneralSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("General")),
      body: const SingleChildScrollView(
        child: SettingsContainer(
          child: Column(
            children: [
              SettingsSection(
                children: [
                  LocaleListTile(),
                  _InstanceAdvertisementsSetting(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InstanceAdvertisementsSetting extends StatelessWidget {
  const _InstanceAdvertisementsSetting();

  @override
  Widget build(BuildContext context) {
    return PreferenceSwitchListTile(
      secondary: const SizedBox(),
      title: const Text("Enable instance advertisements"),
      subtitle: const Text(
        "Show advertisements from your instance",
      ),
      provider: preferences.showAds,
    );
  }
}
