import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/ui/pride.dart";
import "package:kaiteki/ui/settings/preference_slider_list_tile.dart";
import "package:kaiteki/ui/settings/preference_switch_list_tile.dart";
import "package:kaiteki/ui/settings/preference_values_list_tile.dart";
import "package:kaiteki/ui/settings/section_header.dart";
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/ui/settings/settings_section.dart";

class TweaksScreen extends StatelessWidget {
  const TweaksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsTweaks)),
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
            SettingsSection(
              title: SectionHeader(context.l10n.settingsEmojisHeader),
              children: [
                PreferenceSliderListTile.values(
                  provider: emojiScale,
                  title: const Text("Emoji size"),
                  values: const [0.5, 1, 1.5, 2, 2.5, 3],
                  labelBuilder: (value) => "${value}x",
                ),
                PreferenceSwitchListTile(
                  provider: squareEmojis,
                  title: const Text("Square emojis"),
                ),
              ],
            ),
            SettingsSection(
              title: const SectionHeader("Avatars"),
              children: [
                PreferenceSliderListTile.values(
                  provider: avatarCornerRadius,
                  title: const Text("Avatar roundness"),
                  values: const [
                    0,
                    2,
                    4,
                    6,
                    8,
                    12,
                    16,
                    24,
                    32,
                    double.infinity,
                  ],
                  labelBuilder: (value) {
                    if (value >= double.infinity) return "Circle";
                    if (value <= 0) return "Square";
                    return "${value}dp";
                  },
                ),
              ],
            ),
            SettingsSection(
              title: SectionHeader(context.l10n.prideSettingsHeader),
              children: [
                PreferenceSwitchListTile(
                  provider: enablePrideFlag,
                  title: Text(context.l10n.enablePrideFlag),
                ),
                PreferenceValuesListTile(
                  provider: prideFlag,
                  values: PrideFlag.values,
                  title: Text(context.l10n.prideFlag),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
