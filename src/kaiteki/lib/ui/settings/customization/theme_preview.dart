import 'package:flutter/material.dart';
import 'package:kaiteki/ui/settings/customization/customization_basic_page.dart';

class ThemePreview extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final Icon? icon;
  final String name;

  const ThemePreview({
    super.key,
    this.selected = false,
    required this.onTap,
    this.icon,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(8.0);

    final selectedDecoration = BoxDecoration(
      border: Border.all(
        color: colorScheme.primary,
        width: 4.0,
      ),
      borderRadius: borderRadius,
    );

    return Tooltip(
      message: name,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        color: colorScheme.surface,
        child: InkWell(
          onTap: onTap,
          child: DecoratedBox(
            decoration: selected ? selectedDecoration : const BoxDecoration(),
            position: DecorationPosition.foreground,
            child: SizedBox(
              width: 8 * 12,
              height: 8 * 12,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildContent(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    if (icon == null) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: 4.0,
        children: [
          ColorCircle(color: theme.colorScheme.primary),
          ColorCircle(color: theme.colorScheme.secondary),
          if (theme.useMaterial3)
            ColorCircle(color: theme.colorScheme.tertiary),
        ],
      );
    } else {
      return Center(
        child: IconTheme(
          data: IconThemeData(color: theme.colorScheme.onSurface, size: 32),
          child: icon!,
        ),
      );
    }
  }
}
