// TODO(Craftplacer): Clean up and refactor these widgets to be more flexible
import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/theming/default/themes.dart';
import 'package:kaiteki/ui/settings/customization/theme_preview.dart';

class ThemeSelector extends StatelessWidget {
  final ThemeMode theme;
  final Function(ThemeMode mode) onSelected;

  const ThemeSelector({
    Key? key,
    required this.theme,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ThemePreview(
          name: _themeToString(context, ThemeMode.system),
          selected: theme == ThemeMode.system,
          onTap: () => onSelected(ThemeMode.system),
          icon: const Icon(Icons.auto_fix_high_rounded),
        ),
        Theme(
          data: getTheme(Brightness.light, Theme.of(context).useMaterial3),
          child: ThemePreview(
            name: _themeToString(context, ThemeMode.light),
            selected: theme == ThemeMode.light,
            onTap: () => onSelected(ThemeMode.light),
          ),
        ),
        Theme(
          data: getTheme(Brightness.dark, Theme.of(context).useMaterial3),
          child: ThemePreview(
            name: _themeToString(context, ThemeMode.dark),
            selected: theme == ThemeMode.dark,
            onTap: () => onSelected(ThemeMode.dark),
          ),
        ),
      ],
    );
  }

  String _themeToString(BuildContext context, ThemeMode mode) {
    final l10n = context.getL10n();

    switch (mode) {
      case ThemeMode.light:
        return l10n.themeLight;

      case ThemeMode.dark:
        return l10n.themeDark;

      case ThemeMode.system:
        return l10n.themeSystem;
    }
  }
}
