import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/ui/pride.dart";
import "package:kaiteki/ui/settings/customization/theme_selector.dart";
import "package:kaiteki/ui/settings/preference_slider_list_tile.dart";
import "package:kaiteki/ui/settings/preference_switch_list_tile.dart";
import "package:kaiteki/ui/settings/preference_values_list_tile.dart";
import "package:kaiteki/ui/settings/section_header.dart";
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/ui/settings/settings_section.dart";

class CustomizationBasicPage extends ConsumerStatefulWidget {
  const CustomizationBasicPage({super.key});

  @override
  ConsumerState<CustomizationBasicPage> createState() =>
      _CustomizationBasicPageState();
}

class _CustomizationBasicPageState
    extends ConsumerState<CustomizationBasicPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      child: SettingsContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            SettingsSection(
              title: SectionHeader(l10n.theme),
              useCard: false,
              children: [
                ThemeSelector(
                  theme: ref.watch(themeMode).value,
                  onSelected: (value) => ref.read(themeMode).value = value,
                ),
              ],
            ),
            SettingsSection(
              children: [
                PreferenceValuesListTile(
                  provider: themeMode,
                  values: ThemeMode.values,
                  title: const Text("Theme mode"),
                  textBuilder: (context, value) {
                    return Text(
                      switch (value) {
                        ThemeMode.light => context.l10n.themeLight,
                        ThemeMode.dark => context.l10n.themeDark,
                        ThemeMode.system => context.l10n.themeSystem
                      },
                    );
                  },
                ),
                PreferenceSwitchListTile(
                  provider: useMaterial3,
                  title: Text(l10n.useMaterialYou),
                ),
                PreferenceSwitchListTile(
                  provider: useSystemColorScheme,
                  title: Text(l10n.useSystemColorScheme),
                ),
              ],
            ),
            SettingsSection(
              title: const SectionHeader("Posts"),
              children: [
                PreferenceSwitchListTile(
                  provider: showUserBadges,
                  title: const Text("Show user badges"),
                ),
                ListTile(
                  title: const Text("Post layout settings"),
                  onTap: () =>
                      context.push("/settings/customization/post-layout"),
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
