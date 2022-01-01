import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/theming/app_themes/default_app_themes.dart';
import 'package:mdi/mdi.dart';

class CustomizationBasicPage extends ConsumerStatefulWidget {
  const CustomizationBasicPage({Key? key}) : super(key: key);

  @override
  _CustomizationBasicPageState createState() => _CustomizationBasicPageState();
}

class _CustomizationBasicPageState
    extends ConsumerState<CustomizationBasicPage> {
  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(preferenceProvider);
    final l10n = context.getL10n();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Text(
              l10n.theme,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ThemeSelector(
              theme: prefs.get().theme,
              onSelected: (mode) => prefs.update((p) => p..theme = mode),
            ),
          ),
        ],
      ),
    );
  }
}

// TODO(Craftplacer): Clean up and refactor these widgets to be more flexible
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
          icon: const Icon(Mdi.autoFix),
        ),
        Theme(
          data: lightAppTheme.materialTheme,
          child: ThemePreview(
            name: _themeToString(context, ThemeMode.light),
            selected: theme == ThemeMode.light,
            onTap: () => onSelected(ThemeMode.light),
          ),
        ),
        Theme(
          data: darkAppTheme.materialTheme,
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

class ThemePreview extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final Icon? icon;
  final String name;

  const ThemePreview({
    Key? key,
    this.selected = false,
    required this.onTap,
    this.icon,
    required this.name,
  }) : super(key: key);

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
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: 8 * 12,
            height: 8 * 12,
            padding: const EdgeInsets.all(8.0),
            child: _buildContent(context),
            decoration: BoxDecoration(color: colorScheme.surface),
            foregroundDecoration: selected ? selectedDecoration : null,
          ),
        ),
        elevation: 4,
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
          child: icon!,
          data: IconThemeData(
            color: colorScheme.onSurface,
            size: 32,
          ),
        ),
      );
    }
  }
}

class ColorCircle extends StatelessWidget {
  const ColorCircle({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}
