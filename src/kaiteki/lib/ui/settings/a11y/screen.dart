import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/ui/settings/preference_slider_list_tile.dart";
import "package:kaiteki/ui/settings/preference_switch_list_tile.dart";
import "package:kaiteki/ui/settings/preference_values_list_tile.dart";
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/ui/settings/settings_section.dart";

class AccessibilityScreen extends StatelessWidget {
  const AccessibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settingsAccessibility),
      ),
      body: SingleChildScrollView(
        child: SettingsContainer(
          child: Column(
            children: [
              SettingsSection(
                title: const Text("Inclusion"),
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
                ],
              ),
              SettingsSection(
                title: const Text("Ease of use"),
                children: [
                  PreferenceSwitchListTile(
                    secondary: const Icon(Icons.open_in_full_rounded),
                    title: const Text(
                      "Show dedicated Open Post button",
                    ),
                    provider: showDedicatedPostOpenButton,
                  ),
                ],
              ),
              SettingsSection(
                title: const Text("Visuals"),
                children: [
                  PreferenceSwitchListTile(
                    secondary: const Icon(Icons.colorize_rounded),
                    title: const Text(
                      "Show post scopes in color",
                    ),
                    subtitle: const Text(
                      "Shows a distinct color for each scope.",
                    ),
                    provider: coloredPostVisibilities,
                  ),
                ],
              ),
              SettingsSection(
                title: const Text("Text"),
                children: [
                  PreferenceValuesListTile(
                    leading: const Icon(Icons.font_download_rounded),
                    title: const Text("Interface font"),
                    provider: interfaceFont,
                    values: InterfaceFont.values,
                    textBuilder: (_, value) {
                      return Text(
                        switch (value) {
                          InterfaceFont.system => "System default",
                          InterfaceFont.roboto => "Roboto",
                          InterfaceFont.kaiteki => "Kaiteki (default)",
                          InterfaceFont.atkinsonHyperlegible =>
                            "Atkinson Hyperlegible",
                          InterfaceFont.openDyslexic => "OpenDyslexic",
                        },
                      );
                    },
                  ),
                  PreferenceSliderListTile(
                    leading: const Icon(Icons.text_fields_rounded),
                    min: 1.0,
                    max: 3.0,
                    title: Text("Post text size"),
                    provider: postTextSize,
                    divisions: 8,
                  ),
                  PreferenceSwitchListTile(
                    secondary: const Icon(Icons.format_underline_rounded),
                    title: const Text("Underline links"),
                    provider: underlineLinks,
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
