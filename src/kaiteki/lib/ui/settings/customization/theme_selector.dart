// TODO(Craftplacer): Clean up and refactor these widgets to be more flexible
import "package:flutter/material.dart";
import "package:kaiteki/theming/default/themes.dart";
import "package:kaiteki/ui/settings/customization/theme_preview.dart";

class ThemeSelector extends StatelessWidget {
  final ThemeMode theme;
  final Function(ThemeMode mode) onSelected;

  const ThemeSelector({
    super.key,
    required this.theme,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // final app = context.findAncestorWidgetOfExactType<MaterialApp>();
    final m3 = Theme.of(context).useMaterial3;

    final themeSets = [
      (
        light: getDefaultTheme(Brightness.light, m3),
        dark: getDefaultTheme(Brightness.dark, m3),
      ),
      
    ];

    return Wrap(
      runSpacing: 8.0,
      spacing: 8.0,
      children: [
        for (final themeSet in themeSets)
          ThemePreview(
            themeSet.light,
            darkTheme: themeSet.dark,
            name: "Kaiteki",
            selected: theme == ThemeMode.light,
            onTap: () => onSelected(ThemeMode.light),
          ),
      ],
    );
  }
}
