import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/ui/settings/customization/theme_selector.dart";
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
            Padding(
              padding: kSectionSubheaderMargin,
              child: SectionHeader(l10n.theme),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 8.0,
              ),
              child: Center(
                child: ThemeSelector(
                  selected: ref.watch(theme).value,
                  onSelected: (value) => ref.read(theme).value = value,
                ),
              ),
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
              ],
            ),
            SettingsSection(
              children: [
                ListTile(
                  title: const Text("Post appearance"),
                  onTap: () =>
                      context.push("/settings/customization/post-layout"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
