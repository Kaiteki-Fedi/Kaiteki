import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/ui/settings/settings_section.dart";

const kTokenPlaceholder = "• • • • • • • •";

class ThirdPartyScreen extends StatelessWidget {
  const ThirdPartyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settingsThirdPartyServices),
      ),
      body: const SingleChildScrollView(
        child: SettingsContainer(
          child: Column(
            children: [
              SettingsSection(
                children: [
                  ListTile(
                    leading: Icon(Icons.translate_rounded),
                    title: Text("Translation provider"),
                    subtitle: Text("DeepL"),
                  ),
                  ListTile(
                    leading: Icon(Icons.gif_rounded),
                    title: Text("GIF provider"),
                    subtitle: Text("Tenor"),
                  ),
                ],
              ),
              SettingsSection(
                title: Text("Credentials"),
                children: [
                  ListTile(
                    leading: SizedBox(),
                    title: Text("Tenor API key"),
                    subtitle: Text(kTokenPlaceholder),
                  ),
                  ListTile(
                    leading: SizedBox(),
                    title: Text("DeepL API key"),
                    subtitle: Text(kTokenPlaceholder),
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
