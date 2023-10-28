import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/ui/settings/customization/dialog.dart";
import "package:kaiteki/ui/settings/customization/theme_selector.dart";
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/ui/settings/settings_section.dart";
import "package:kaiteki/utils/extensions.dart";

class CustomizationSettingsScreen extends ConsumerWidget {
  const CustomizationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    Future<void> onChangeTheme() async {
      final result = await showDialog(
        context: context,
        builder: (_) => ThemeDialog(
          (
            themeMode: ref.read(themeMode).value,
            useMaterial3: ref.read(useMaterial3).value,
          ),
        ),
      );

      if (result == null) return;

      ref.read(themeMode).value = result.themeMode;
      ref.read(useMaterial3).value = result.useMaterial3;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsCustomization)),
      body: SingleChildScrollView(
        child: SettingsContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                child: Center(
                  child: ThemeSelector(
                    selected: ref.watch(theme).value,
                    onSelected: (value) => ref.read(theme).value = value,
                  ),
                ),
              ),
              SettingsSection(
                children: [
                  ListTile(
                    title: Text(context.l10n.theme),
                    subtitle: Text(
                      ref.watch(themeMode).value.getDisplayString(context.l10n),
                    ),
                    onTap: onChangeTheme,
                  ),
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
      ),
    );
  }
}
