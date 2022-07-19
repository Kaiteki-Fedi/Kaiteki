import 'package:flutter/material.dart';
import 'package:kaiteki/utils/extensions.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text("Theme")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ListTile(title: Text("Material colors")),
            Card(
              margin: padding,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ColorPatch(
                    "Background",
                    colorScheme.background,
                    colorScheme.onBackground,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _ColorPatch(
                          "Surface",
                          colorScheme.surface,
                          colorScheme.onSurface,
                        ),
                      ),
                      Expanded(
                        child: _ColorPatch(
                          "Variant",
                          colorScheme.surfaceVariant,
                          colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _ColorPatch(
                          "Primary",
                          colorScheme.primary,
                          colorScheme.onPrimary,
                        ),
                      ),
                      Expanded(
                        child: _ColorPatch(
                          "Container",
                          colorScheme.primaryContainer,
                          colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _ColorPatch(
                          "Secondary",
                          colorScheme.secondary,
                          colorScheme.onSecondary,
                        ),
                      ),
                      Expanded(
                        child: _ColorPatch(
                          "Container",
                          colorScheme.secondaryContainer,
                          colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _ColorPatch(
                          "Tertiary",
                          colorScheme.tertiary,
                          colorScheme.onTertiary,
                        ),
                      ),
                      Expanded(
                        child: _ColorPatch(
                          "Container",
                          colorScheme.tertiaryContainer,
                          colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _ColorPatch(
                          "Error",
                          colorScheme.error,
                          colorScheme.onError,
                        ),
                      ),
                      Expanded(
                        child: _ColorPatch(
                          "Container",
                          colorScheme.errorContainer,
                          colorScheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const ListTile(title: Text("Custom Kaiteki colors")),
            ListTile(
              leading: Icon(
                Icons.star_rounded,
                color: context.getKaitekiTheme()?.favoriteColor,
                size: 24,
              ),
              title: const Text("Favorite"),
            ),
            ListTile(
              leading: Icon(
                Icons.repeat_rounded,
                color: context.getKaitekiTheme()?.repeatColor,
                size: 24,
              ),
              title: const Text("Repeat"),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorPatch extends StatelessWidget {
  final Color background;
  final Color foreground;
  final String label;

  const _ColorPatch(this.label, this.background, this.foreground);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: background,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Text(
          label,
          style: TextStyle(color: foreground),
        ),
      ),
    );
  }
}
