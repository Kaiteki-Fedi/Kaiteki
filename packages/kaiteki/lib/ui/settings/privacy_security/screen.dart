import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart" as preferences;
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/ui/settings/settings_section.dart";

class PrivacySecuritySettingsScreen extends ConsumerWidget {
  const PrivacySecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy and security"),
      ),
      body: SingleChildScrollView(
        child: SettingsContainer(
          child: Column(
            children: [
              SettingsSection(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.open_in_new_off_rounded),
                    title: const Text("Warn when leaving Kaiteki"),
                    subtitle: const Text(
                      "Show a warning when opening links to external websites. Only works for ads at the moment.",
                    ),
                    value: ref.watch(preferences.linkWarningPolicy).value !=
                        preferences.LinkWarningPolicy.never,
                    onChanged: (value) {
                      ref.read(preferences.linkWarningPolicy).value = value
                          ? preferences.LinkWarningPolicy.always
                          : preferences.LinkWarningPolicy.never;
                    },
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
