import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:kaiteki/preferences/theme_preferences.dart" as preferences;
import "package:kaiteki/ui/shared/emoji/emoji_theme.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/ui/shared/posts/post_widget_theme.dart";

extension ThemeDataExtensions on ThemeData {
  ThemeData applyUserPreferences(WidgetRef ref) {
    ShapeBorder getAvatarShape(double cornerRadius) {
      return switch (cornerRadius) {
        <= 0 => const Border(),
        >= double.infinity => const CircleBorder(),
        _ => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornerRadius),
          ),
      };
    }

    final avatarCornerRadius = ref.watch(preferences.avatarCornerRadius).value;
    final useNaturalBadgeColors =
        ref.watch(preferences.useNaturalBadgeColors).value;

    return copyWith(
      extensions: [
        ...extensions.values,
        EmojiTheme(square: ref.watch(preferences.squareEmojis).value),
        AvatarTheme(shape: getAvatarShape(avatarCornerRadius)),
        PostWidgetThemeData(
          useCards: ref.watch(preferences.usePostCards).value,
        ),
      ],
      badgeTheme: useNaturalBadgeColors
          ? badgeTheme.copyWith(
              backgroundColor: colorScheme.inverseSurface,
              textColor: colorScheme.onInverseSurface,
            )
          : null,
      visualDensity: ref.watch(preferences.visualDensity).value,
    );
  }

  ThemeData applyTweaks() {
    return copyWith(
      snackBarTheme: snackBarTheme.copyWith(
        behavior: SnackBarBehavior.floating,
        width: 600,
        insetPadding: EdgeInsets.all(16.0),
      ),
      floatingActionButtonTheme: floatingActionButtonTheme.copyWith(
        extendedTextStyle: textTheme.labelLarge,
      ),
      appBarTheme: appBarTheme.copyWith(),
      bottomNavigationBarTheme: bottomNavigationBarTheme.copyWith(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      bottomSheetTheme: bottomSheetTheme.copyWith(showDragHandle: true),
      dividerTheme: dividerTheme.copyWith(space: 1, thickness: 1),
    );
  }

  ThemeData addContrast() {
    final outlinedBorderSide =
    BorderSide(color: colorScheme.outlineVariant);

    return copyWith(
      cardTheme: cardTheme.copyWith(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ).copyWith(side: outlinedBorderSide),
        shadowColor: Colors.transparent,
        margin: EdgeInsets.zero,
      ),
      searchBarTheme: searchBarTheme.copyWith(
        shape: MaterialStatePropertyAll(
          StadiumBorder(side: outlinedBorderSide),
        ),
      ),
    );
  }
}
