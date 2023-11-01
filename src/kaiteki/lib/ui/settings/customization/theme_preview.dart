import "package:flutter/material.dart";

class ThemePreview extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final String name;
  final ThemeData theme;
  final ThemeData? darkTheme;
  final Widget icon;

  const ThemePreview(
    this.theme, {
    super.key,
    this.selected = false,
    required this.onTap,
    required this.name,
    this.darkTheme,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final useMaterial3 = Theme.of(context).useMaterial3;

    final themeData = switch (Theme.of(context).brightness) {
      Brightness.light => theme,
      Brightness.dark => darkTheme ?? theme,
    };

    Color? color;

    if (!useMaterial3) {
      if (selected) {
        color = Theme.of(context).colorScheme.primary;
      } else {
        final onSurface = Theme.of(context).colorScheme.onSurface;
        color = switch (Theme.of(context).brightness) {
          Brightness.dark => onSurface.withOpacity(.7),
          Brightness.light => onSurface.withOpacity(.54),
        };
      }
    }

    return Column(
      children: [
        Theme(
          data: themeData,
          child: IconButton.filled(
            isSelected: selected,
            style: IconButton.styleFrom(),
            onPressed: onTap,
            icon: icon,
            tooltip: name,
            splashRadius: 24.0,
            color: color,
            selectedIcon: const Icon(Icons.check_rounded),
            visualDensity: const VisualDensity(horizontal: 1.0, vertical: 1.0),
          ),
        ),
      ],
    );
  }
}
