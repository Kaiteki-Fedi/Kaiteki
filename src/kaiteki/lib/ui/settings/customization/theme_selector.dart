// TODO(Craftplacer): Clean up and refactor these widgets to be more flexible
import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/l10n/localizations.dart";
import "package:kaiteki/theming/default/themes.dart";
import "package:kaiteki/theming/themes.dart";
import "package:kaiteki/ui/settings/customization/theme_preview.dart";
import "package:kaiteki/ui/shared/common.dart";

class ThemeSelector extends ConsumerWidget {
  final AppTheme? selected;
  final ValueChanged<AppTheme?> onSelected;

  const ThemeSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final app = context.findAncestorWidgetOfExactType<MaterialApp>();
    final systemColorSchemes = ref.watch(systemColorSchemeProvider);

    // In Material 3, we apply a background color to the icon buttons.
    return Wrap(
      runSpacing: 8.0,
      spacing: 8.0,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (systemColorSchemes != null) ...[
          ThemePreview(
            ThemeData.from(colorScheme: systemColorSchemes.light),
            darkTheme: ThemeData.from(colorScheme: systemColorSchemes.dark),
            name: "System Default",
            icon: const Icon(Icons.auto_awesome_rounded),
            selected: selected == null,
            onTap: () => onSelected(null),
          ),
          const SizedBox(
            height: 24,
            child: VerticalDivider(width: 1),
          ),
        ],
        for (final theme in AppTheme.values)
          ThemePreview(
            makeTheme(theme.getColorScheme(Brightness.light)),
            darkTheme: makeTheme(theme.getColorScheme(Brightness.dark)),
            name: _getThemeName(theme, context.l10n),
            icon: _buildThemeIcon(theme),
            selected: selected == theme,
            onTap: () => onSelected(theme),
          ),
      ],
    );
  }
}

String _getThemeName(AppTheme theme, KaitekiLocalizations l10n) {
  return switch (theme) {
    AppTheme.affection => l10n.themeAffection,
    AppTheme.joy => l10n.themeJoy,
    AppTheme.comfort => l10n.themeComfort,
    AppTheme.compassion => l10n.themeCompassion,
    AppTheme.serenity => l10n.themeSerenity,
    AppTheme.spirit => l10n.themeSpirit,
    AppTheme.care => l10n.themeCare,
  };
}

Icon _buildThemeIcon(AppTheme? theme) {
  return switch (theme) {
    AppTheme.affection => const Icon(Icons.favorite_rounded),
    AppTheme.joy => const Icon(Icons.sentiment_very_satisfied_rounded),
    AppTheme.comfort => const Icon(Icons.wb_sunny_rounded),
    AppTheme.compassion => const Icon(Icons.handshake_rounded),
    AppTheme.serenity => const Icon(Icons.local_florist_rounded),
    AppTheme.spirit => const Icon(Icons.self_improvement_rounded),
    AppTheme.care => const Icon(Icons.cruelty_free_rounded),
    null => const Icon(Icons.auto_awesome_rounded),
  };
}
