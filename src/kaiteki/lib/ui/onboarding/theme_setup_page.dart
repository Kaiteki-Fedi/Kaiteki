import "package:flutter/material.dart";
import "package:kaiteki/di.dart";

class ThemeSetupPage extends ConsumerWidget {
  const ThemeSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(themeProvider);

    void setMode(ThemeMode? value) {
      if (value == null) return;
      prefs.mode = value;
    }

    return ListView(
      children: [
        RadioListTile<ThemeMode>(
          title: Text(context.l10n.themeSystem),
          value: ThemeMode.system,
          groupValue: prefs.mode,
          onChanged: setMode,
        ),
        RadioListTile<ThemeMode>(
          title: Text(context.l10n.themeLight),
          value: ThemeMode.light,
          groupValue: prefs.mode,
          onChanged: setMode,
        ),
        RadioListTile<ThemeMode>(
          title: Text(context.l10n.themeDark),
          value: ThemeMode.dark,
          groupValue: prefs.mode,
          onChanged: setMode,
        ),
      ],
    );
  }
}
