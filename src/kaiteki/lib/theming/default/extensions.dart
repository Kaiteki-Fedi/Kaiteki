import "package:flutter/material.dart";
import "package:kaiteki/theming/kaiteki/theme.dart";
import "package:kaiteki/ui/shared/emoji/emoji_theme.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";

extension ThemeDataExtensions on ThemeData {
  ThemeData applyDefaultTweaks({bool useNaturalBadgeColors = false}) {
    final navigationBarForegroundColor =
        colorScheme.brightness == Brightness.dark
            ? colorScheme.onSurface
            : colorScheme.onPrimary;
    return copyWith(
      snackBarTheme: snackBarTheme.copyWith(
        behavior: SnackBarBehavior.floating,
      ),
      badgeTheme: badgeTheme.copyWith(
        backgroundColor:
            useNaturalBadgeColors ? colorScheme.inverseSurface : null,
        textColor: useNaturalBadgeColors ? colorScheme.onInverseSurface : null,
      ),
      floatingActionButtonTheme: floatingActionButtonTheme.copyWith(
        extendedTextStyle: textTheme.labelLarge ?? const TextStyle(),
      ),
      dividerTheme: dividerTheme.copyWith(space: 1, thickness: 1),
      tabBarTheme: tabBarTheme.copyWith(
        labelColor: useMaterial3 ? null : colorScheme.primary,
        indicatorColor: useMaterial3 ? null : colorScheme.primary,
        indicator: useMaterial3
            ? null
            : BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: colorScheme.primary, width: 2),
                ),
              ),

        unselectedLabelColor: useMaterial3
            ? null
            : colorScheme.onSurface.withOpacity(.6) /* medium emphasis */,
        // And there @Craftplacer said, "THIS DIVIDER SUCKS"
        dividerColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: bottomNavigationBarTheme.copyWith(
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
