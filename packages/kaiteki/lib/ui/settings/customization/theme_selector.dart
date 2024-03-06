// TODO(Craftplacer): Clean up and refactor these widgets to be more flexible
import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/theming/accent.dart";
import "package:kaiteki/ui/settings/customization/theme_preview.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki_l10n/kaiteki_l10n.dart";

class ThemeSelector extends ConsumerWidget {
  final AppAccent? selected;
  final ValueChanged<AppAccent> onSelected;

  const ThemeSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final app = context.findAncestorWidgetOfExactType<MaterialApp>();
    final systemColorSchemes = ref.watch(systemColorSchemeProvider);

    final l10n = context.l10n;

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
            name: _getThemeName(AppAccent.system, l10n),
            icon: _buildThemeIcon(AppAccent.system),
            selected: selected == AppAccent.system,
            onTap: () => onSelected(AppAccent.system),
          ),
          const SizedBox(
            height: 24,
            child: VerticalDivider(width: 1),
          ),
        ],
        for (final theme in AppAccent.values)
          if (theme != AppAccent.system)
            ThemePreview(
              ThemeData.from(
                colorScheme: theme.getColorScheme(Brightness.light)!,
              ),
              darkTheme: ThemeData.from(
                colorScheme: theme.getColorScheme(Brightness.dark)!,
              ),
              name: _getThemeName(theme, l10n),
              icon: _buildThemeIcon(theme),
              selected: selected == theme,
              onTap: () => onSelected(theme),
            ),
      ],
    );
  }
}

String _getThemeName(AppAccent theme, KaitekiLocalizations l10n) {
  return switch (theme) {
    AppAccent.affection => l10n.themeAffection,
    AppAccent.joy => l10n.themeJoy,
    AppAccent.comfort => l10n.themeComfort,
    AppAccent.compassion => l10n.themeCompassion,
    AppAccent.serenity => l10n.themeSerenity,
    AppAccent.spirit => l10n.themeSpirit,
    AppAccent.care => l10n.themeCare,
    AppAccent.system => l10n.themeSystem,
  };
}

Icon _buildThemeIcon(AppAccent theme) {
  return switch (theme) {
    AppAccent.affection => const Icon(Icons.favorite_rounded),
    AppAccent.joy => const Icon(Icons.sentiment_very_satisfied_rounded),
    AppAccent.comfort => const Icon(Icons.wb_sunny_rounded),
    AppAccent.compassion => const Icon(Icons.handshake_rounded),
    AppAccent.serenity => const Icon(Icons.local_florist_rounded),
    AppAccent.spirit => const Icon(Icons.self_improvement_rounded),
    AppAccent.care => const Icon(Icons.cruelty_free_rounded),
    AppAccent.system => const Icon(Icons.auto_awesome_rounded),
  };
}
