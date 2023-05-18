import "package:flutter/material.dart";

class ThemePreview extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final String name;
  final ThemeData theme;
  final ThemeData? darkTheme;

  const ThemePreview(
    this.theme, {
    super.key,
    this.selected = false,
    required this.onTap,
    required this.name,
    this.darkTheme,
  });

  @override
  Widget build(BuildContext context) {
    final useMaterial3 = Theme.of(context).useMaterial3;
    final borderRadius =
        useMaterial3 ? BorderRadius.circular(12.0) : BorderRadius.circular(4.0);

    final selectedDecoration = BoxDecoration(
      border: Border.all(
        color: theme.colorScheme.primary,
        width: 4.0,
      ),
      borderRadius: borderRadius,
    );

    final themes = [
      theme,
      if (darkTheme != null) darkTheme!,
    ];
    return Tooltip(
      message: name,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        elevation: useMaterial3 ? 0.0 : null,
        color: useMaterial3
            ? theme.colorScheme.surfaceVariant
            : theme.colorScheme.surface,
        child: InkWell(
          onTap: onTap,
          child: DecoratedBox(
            decoration: selected ? selectedDecoration : const BoxDecoration(),
            position: DecorationPosition.foreground,
            child: Column(
              children: [
                for (final theme in themes)
                  Theme(
                    data: theme,
                    child: SizedBox(
                      width: 8 * 12,
                      height: (8 * 12) / themes.length,
                      child: _ThemePreview(theme: theme),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemePreview extends StatelessWidget {
  const _ThemePreview({
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: theme.useMaterial3
          ? theme.colorScheme.surfaceVariant
          : theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 4.0,
          children: [
            _ColorCircle(color: theme.colorScheme.primary),
            _ColorCircle(color: theme.colorScheme.secondary),
            if (theme.useMaterial3)
              _ColorCircle(color: theme.colorScheme.tertiary),
          ],
        ),
      ),
    );
  }
}

class _ColorCircle extends StatelessWidget {
  const _ColorCircle({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: const SizedBox.square(dimension: 16),
    );
  }
}
