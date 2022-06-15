import 'package:flutter/material.dart';
import 'package:kaiteki/utils/extensions.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text("Theme")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ListTile(title: Text("Material colors")),
            Padding(
              padding: padding,
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  Chip(
                    backgroundColor: colorScheme.background,
                    label: Text(
                      "Background",
                      style: TextStyle(color: colorScheme.onBackground),
                    ),
                  ),
                  Chip(
                    backgroundColor: colorScheme.surface,
                    label: Text(
                      "Surface",
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                  ),
                  Chip(
                    backgroundColor: colorScheme.surfaceVariant,
                    label: Text(
                      "Surface Variant",
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                  Chip(
                    backgroundColor: colorScheme.primary,
                    label: Text(
                      "Primary",
                      style: TextStyle(color: colorScheme.onPrimary),
                    ),
                  ),
                  Chip(
                    backgroundColor: colorScheme.primaryContainer,
                    label: Text(
                      "Primary Container",
                      style: TextStyle(color: colorScheme.onPrimaryContainer),
                    ),
                  ),
                  Chip(
                    backgroundColor: colorScheme.secondary,
                    label: Text(
                      "Secondary",
                      style: TextStyle(color: colorScheme.onSecondary),
                    ),
                  ),
                  Chip(
                    backgroundColor: colorScheme.secondaryContainer,
                    label: Text(
                      "Secondary Container",
                      style: TextStyle(color: colorScheme.onSecondaryContainer),
                    ),
                  ),
                  Chip(
                    backgroundColor: colorScheme.tertiary,
                    label: Text(
                      "Teritary",
                      style: TextStyle(color: colorScheme.onTertiary),
                    ),
                  ),
                  Chip(
                    backgroundColor: colorScheme.tertiaryContainer,
                    label: Text(
                      "Teritary Container",
                      style: TextStyle(color: colorScheme.onTertiaryContainer),
                    ),
                  ),
                  Chip(
                    backgroundColor: colorScheme.error,
                    label: Text(
                      "Error",
                      style: TextStyle(color: colorScheme.onError),
                    ),
                  ),
                  Chip(
                    backgroundColor: colorScheme.errorContainer,
                    label: Text(
                      "Error Container",
                      style: TextStyle(color: colorScheme.onErrorContainer),
                    ),
                  ),
                ],
              ),
            ),
            const ListTile(title: Text("Custom Kaiteki colors")),
            Padding(
              padding: padding,
              child: Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: context.getKaitekiTheme()?.favoriteColor,
                    size: 32,
                  ),
                  Icon(
                    Icons.repeat_rounded,
                    color: context.getKaitekiTheme()?.repeatColor,
                    size: 32,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
