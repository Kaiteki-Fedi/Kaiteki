import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

class KaitekiColors extends ThemeExtension<KaitekiColors> {
  /// Primary color used for bookmarks.
  final Color bookmarkColor;

  /// Primary color used for favorites.
  final Color favoriteColor;

  /// Primary color used for repeats.
  final Color repeatColor;

  const KaitekiColors({
    required this.bookmarkColor,
    required this.favoriteColor,
    required this.repeatColor,
  });

  factory KaitekiColors.fromMaterialTheme(ThemeData theme) {
    final primaryColor = theme.colorScheme.primary;
    return KaitekiColors(
      bookmarkColor: Colors.pink.harmonizeWith(primaryColor),
      favoriteColor: Colors.orange.harmonizeWith(primaryColor),
      repeatColor: Colors.green.harmonizeWith(primaryColor),
    );
  }

  @override
  KaitekiColors copyWith({
    Color? bookmarkColor,
    Color? favoriteColor,
    Color? repeatColor,
  }) {
    return KaitekiColors(
      bookmarkColor: bookmarkColor ?? this.bookmarkColor,
      favoriteColor: favoriteColor ?? this.favoriteColor,
      repeatColor: repeatColor ?? this.repeatColor,
    );
  }

  @override
  KaitekiColors lerp(ThemeExtension<KaitekiColors>? other, double t) {
    if (other is! KaitekiColors) return this;

    return KaitekiColors(
      bookmarkColor: Color.lerp(bookmarkColor, other.bookmarkColor, t)!,
      favoriteColor: Color.lerp(favoriteColor, other.favoriteColor, t)!,
      repeatColor: Color.lerp(repeatColor, other.repeatColor, t)!,
    );
  }
}

extension ThemeExtensions on ThemeData {
  KaitekiColors? get ktkColors => extension<KaitekiColors>();
}
