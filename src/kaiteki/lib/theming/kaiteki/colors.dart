import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/material.dart";
import "package:kaiteki/ui/shared/common.dart";

class KaitekiColors extends ThemeExtension<KaitekiColors> {
  /// Primary color used for bookmarks.
  final Color? bookmarkColor;

  /// Primary color used for favorites.
  final Color? favoriteColor;

  /// Primary color used for repeats.
  final Color? repeatColor;

  const KaitekiColors({
    this.bookmarkColor,
    this.favoriteColor,
    this.repeatColor,
  });

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
      bookmarkColor: Color.lerp(bookmarkColor, other.bookmarkColor, t),
      favoriteColor: Color.lerp(favoriteColor, other.favoriteColor, t),
      repeatColor: Color.lerp(repeatColor, other.repeatColor, t),
    );
  }
}

class DefaultKaitekiColors extends KaitekiColors {
  final BuildContext _context;

  const DefaultKaitekiColors(BuildContext context)
      : _context = context,
        super();

  @override
  Color get bookmarkColor => _harmonize(Colors.pink);

  @override
  Color get favoriteColor => _harmonize(Colors.orange);

  @override
  Color get repeatColor => _harmonize(Colors.green);

  Color _harmonize(Color base) {
    final colorScheme = Theme.of(_context).colorScheme;
    return createCustomColorPalette(
      base.harmonizeWith(colorScheme.primary),
      colorScheme.brightness,
    ).color;
  }
}

extension ThemeExtensions on ThemeData {
  KaitekiColors? get ktkColors => extension<KaitekiColors>();
}
