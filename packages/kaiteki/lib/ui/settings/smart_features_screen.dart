import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/ui/settings/preference_switch_list_tile.dart";
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/ui/settings/settings_section.dart";

class SmartFeaturesSettingsScreen extends ConsumerStatefulWidget {
  const SmartFeaturesSettingsScreen({super.key});

  @override
  ConsumerState<SmartFeaturesSettingsScreen> createState() =>
      _SmartFeaturesScreenState();
}

class _SmartFeaturesScreenState
    extends ConsumerState<SmartFeaturesSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart features")),
      body: SingleChildScrollView(
        child: SettingsContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsSection(
                children: [
                  PreferenceSwitchListTile(
                    provider: highlightPronouns,
                    title: const Text("Show pronouns"),
                    subtitle: const Text(
                      "Extracts pronouns from profile fields and displays them next to the user's name",
                    ),
                    secondary: const Icon(Icons.loyalty_rounded),
                  ),
                  const SwitchListTile(
                    title: Text("Warn about NSFW profiles"),
                    subtitle: Text(
                      "Warns when visiting a profile that seems to be NSFW",
                    ),
                    secondary: Icon(Icons.no_adult_content_rounded),
                    value: false,
                    onChanged: null,
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
