import "package:flutter/material.dart";
import "package:kaiteki/theming/kaiteki/colors.dart";
import "package:kaiteki/ui/settings/section_header.dart";
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/ui/settings/settings_section.dart";

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final defaults = DefaultKaitekiColors(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Theme")),
      body: SingleChildScrollView(
        child: SettingsContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SettingsSection(
                title: const SectionHeader("Material colors"),
                divideChildren: false,
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
              SettingsSection(
                title: const SectionHeader("Kaiteki colors"),
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.star_rounded,
                      color: Theme.of(context).ktkColors?.favoriteColor ??
                          defaults.favoriteColor,
                      size: 24,
                    ),
                    title: const Text("Favorite"),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.repeat_rounded,
                      color: Theme.of(context).ktkColors?.repeatColor ??
                          defaults.repeatColor,
                      size: 24,
                    ),
                    title: const Text("Repeat"),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.bookmark_rounded,
                      color: Theme.of(context).ktkColors?.bookmarkColor ??
                          defaults.bookmarkColor,
                      size: 24,
                    ),
                    title: const Text("Bookmark"),
                  ),
                ],
              ),
            ],
          ),
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
