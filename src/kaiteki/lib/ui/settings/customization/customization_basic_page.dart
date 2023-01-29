import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/ui/settings/customization/theme_selector.dart";
import "package:kaiteki/ui/settings/preference_switch_list_tile.dart";
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
          ],
        ),
      ),
    );
  }
}
