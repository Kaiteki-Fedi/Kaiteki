import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/ui/settings/settings_section.dart";

class SmartFeaturesScreen extends ConsumerStatefulWidget {
  const SmartFeaturesScreen({super.key});

  @override
  ConsumerState<SmartFeaturesScreen> createState() =>
      _SmartFeaturesScreenState();
}

class _SmartFeaturesScreenState extends ConsumerState<SmartFeaturesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart features")),
      body: const SingleChildScrollView(
        child: SettingsContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsSection(
                children: [
                  SwitchListTile(
                    title: Text("Show pronouns"),
                    subtitle: Text(
                      "Extracts pronouns from profile fields and displays them next to the user's name",
                    ),
                    secondary: Icon(Icons.loyalty_rounded),
                    value: false,
                    onChanged: null,
                  ),
                  SwitchListTile(
                    title: Text("Web links"),
                    subtitle: Text(
                      "Extracts links from profile fields and displays them in a row",
                    ),
                    secondary: Icon(Icons.link_rounded),
                    value: true,
                    onChanged: null,
                  ),
                  SwitchListTile(
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
