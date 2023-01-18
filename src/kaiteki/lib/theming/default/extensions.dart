import "package:flutter/material.dart";
import "package:kaiteki/theming/kaiteki/colors.dart";
import "package:kaiteki/theming/kaiteki/post.dart";
import "package:kaiteki/theming/kaiteki/text_theme.dart";
import "package:kaiteki/theming/kaiteki/theme.dart";
import "package:kaiteki_material/kaiteki_material.dart";

extension ThemeDataExtensions on ThemeData {
  ThemeData applyDefaultTweaks() {
    final navigationBarForegroundColor =
        colorScheme.brightness == Brightness.dark
            ? colorScheme.onSurface
            : colorScheme.onPrimary;
    return copyWith(
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: dividerTheme.copyWith(space: 1, thickness: 1),
      tabBarTheme: TabBarTheme(
        indicator: RoundedUnderlineTabIndicator(
          borderSide: BorderSide(width: 3, color: colorScheme.primary),
        ),
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        // And there @Craftplacer said, "THIS DIVIDER SUCKS"
        dividerColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.brightness == Brightness.dark
            ? colorScheme.surface
            : colorScheme.primary,
        selectedItemColor: navigationBarForegroundColor,
        unselectedItemColor: navigationBarForegroundColor.withOpacity(0.76),
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  /// Adds Kaiteki-specific extensions to the theme.
  ThemeData addKaitekiExtensions() {
    return copyWith(
      extensions: [
        ...extensions.values,
        KaitekiTextTheme.fromMaterialTheme(this),
        KaitekiColors.fromMaterialTheme(this),
        KaitekiTheme.fromMaterialTheme(this),
        KaitekiPostTheme.fallback,
      ],
    );
  }
}
