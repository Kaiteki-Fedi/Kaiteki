import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/theme_preferences.dart";

class ThemeSetupPage extends ConsumerWidget {
  const ThemeSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupValue = ref.watch(themeMode).value;

    void setMode(ThemeMode? value) {
      if (value == null) return;
      ref.read(themeMode).value = value;
    }

    return ListView(
      children: [
        RadioListTile<ThemeMode>(
          title: Text(context.l10n.themeSystem),
          value: ThemeMode.system,
          groupValue: groupValue,
          onChanged: setMode,
        ),
        RadioListTile<ThemeMode>(
          title: Text(context.l10n.themeLight),
          value: ThemeMode.light,
          groupValue: groupValue,
          onChanged: setMode,
        ),
        RadioListTile<ThemeMode>(
          title: Text(context.l10n.themeDark),
          value: ThemeMode.dark,
          groupValue: groupValue,
          onChanged: setMode,
        ),
      ],
    );
  }
}
