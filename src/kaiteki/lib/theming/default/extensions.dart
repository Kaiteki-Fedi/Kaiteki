import "package:flutter/material.dart";
import "package:kaiteki/theming/kaiteki/theme.dart";
import "package:kaiteki/ui/shared/emoji/emoji_theme.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki_material/kaiteki_material.dart";

extension ThemeDataExtensions on ThemeData {
  ThemeData applyDefaultTweaks({bool useNaturalBadgeColors = false}) {
    final navigationBarForegroundColor =
        colorScheme.brightness == Brightness.dark
            ? colorScheme.onSurface
            : colorScheme.onPrimary;
    return copyWith(
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor:
            useNaturalBadgeColors ? colorScheme.inverseSurface : null,
        textColor: useNaturalBadgeColors ? colorScheme.onInverseSurface : null,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        extendedTextStyle: textTheme.labelLarge ?? const TextStyle(),
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
  ThemeData addKaitekiExtensions({
    bool? squareEmoji,
    ShapeBorder? avatarShape,
  }) {
    return copyWith(
      extensions: [
        ...extensions.values,
        KaitekiTheme.fromMaterialTheme(this),
        EmojiTheme(square: squareEmoji ?? true),
        AvatarTheme(shape: avatarShape ?? const CircleBorder()),
      ],
    );
  }
}
