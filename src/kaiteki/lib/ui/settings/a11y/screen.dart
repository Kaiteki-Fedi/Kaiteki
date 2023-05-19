import "package:flutter/material.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/ui/settings/preference_switch_list_tile.dart";
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/ui/settings/settings_section.dart";

class AccessibilityScreen extends StatelessWidget {
  const AccessibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Accessibility")),
      body: SingleChildScrollView(
        child: SettingsContainer(
          child: Column(
            children: [
              SettingsSection(
                children: [
                  PreferenceSwitchListTile(
                    secondary: const Icon(Icons.image_rounded),
                    title: const Text(
                      "Show warning for missing attachment descriptions",
                    ),
                    subtitle: const Text(
                      "Prevent you from accidentally uploading attachments without a description",
                    ),
                    provider: showAttachmentDescriptionWarning,
                  ),
                  PreferenceSwitchListTile(
                    secondary: const Icon(Icons.open_in_full_rounded),
                    title: const Text(
                      "Show dedicated post open button",
                    ),
                    subtitle: const Text(
                      "Adds a button for opening the conversation of a post without having to click on the post itself.",
                    ),
                    provider: showDedicatedPostOpenButton,
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
