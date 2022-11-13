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
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: 8 * 12,
            height: 8 * 12,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(color: colorScheme.surface),
            foregroundDecoration: selected ? selectedDecoration : null,
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (icon == null) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: 4.0,
        children: [
          ColorCircle(color: colorScheme.onSurface),
          ColorCircle(color: colorScheme.primary),
          ColorCircle(color: colorScheme.secondary),
        ],
      );
    } else {
      return Center(
        child: IconTheme(
          data: IconThemeData(
            color: colorScheme.onSurface,
            size: 32,
          ),
          child: icon!,
        ),
      );
    }
  }
}
