import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class KaitekiTextTheme extends ThemeExtension<KaitekiTextTheme> {
  /// Text style used for hashtags.
  final TextStyle? hashtagTextStyle;

  /// Text style used for links.
  final TextStyle? linkTextStyle;

  /// Text style used for mentions.
  final TextStyle? mentionTextStyle;

  final TextStyle? monospaceTextStyle;

  /// Text style used for numbers.
  final TextStyle? countTextStyle;

  /// Brand text style used for the Kaiteki logo.
  final TextStyle? kaitekiTextStyle;

  const KaitekiTextTheme({
    this.hashtagTextStyle,
    this.linkTextStyle,
    this.mentionTextStyle,
    this.monospaceTextStyle,
    this.countTextStyle,
    this.kaitekiTextStyle,
  });

  @override
  ThemeExtension<KaitekiTextTheme> copyWith({
    TextStyle? hashtagTextStyle,
    TextStyle? linkTextStyle,
    TextStyle? mentionTextStyle,
    TextStyle? monospaceTextStyle,
    TextStyle? countTextStyle,
    TextStyle? kaitekiTextStyle,
    double? emojiScale,
  }) {
    return KaitekiTextTheme(
      linkTextStyle: linkTextStyle ?? this.linkTextStyle,
      hashtagTextStyle: hashtagTextStyle ?? this.hashtagTextStyle,
      mentionTextStyle: mentionTextStyle ?? this.mentionTextStyle,
      monospaceTextStyle: monospaceTextStyle ?? this.monospaceTextStyle,
      countTextStyle: countTextStyle ?? this.countTextStyle,
      kaitekiTextStyle: kaitekiTextStyle ?? this.kaitekiTextStyle,
    );
  }

  @override
  KaitekiTextTheme lerp(ThemeExtension<KaitekiTextTheme>? other, double t) {
    if (other is! KaitekiTextTheme) return this;

    return KaitekiTextTheme(
      linkTextStyle: TextStyle.lerp(linkTextStyle, other.linkTextStyle, t),
      hashtagTextStyle: TextStyle.lerp(
        hashtagTextStyle,
        other.hashtagTextStyle,
        t,
      ),
      mentionTextStyle: TextStyle.lerp(
        mentionTextStyle,
        other.mentionTextStyle,
        t,
      ),
      monospaceTextStyle: TextStyle.lerp(
        monospaceTextStyle,
        other.monospaceTextStyle,
        t,
      ),
      countTextStyle: TextStyle.lerp(
        countTextStyle,
        other.countTextStyle,
        t,
      ),
      kaitekiTextStyle: TextStyle.lerp(
        kaitekiTextStyle,
        other.kaitekiTextStyle,
        t,
      ),
    );
  }
}

class DefaultKaitekiTextTheme extends KaitekiTextTheme {
  final BuildContext _context;

  const DefaultKaitekiTextTheme(BuildContext context)
      : _context = context,
        super();

  TextStyle get _accentTextStyle {
    return TextStyle(color: Theme.of(_context).colorScheme.secondary);
  }

  @override
  TextStyle get hashtagTextStyle => _accentTextStyle;

  @override
  TextStyle get linkTextStyle => _accentTextStyle;

  @override
  TextStyle get mentionTextStyle => _accentTextStyle;

  @override
  TextStyle get monospaceTextStyle => GoogleFonts.firaMono();

  @override
  TextStyle get countTextStyle => GoogleFonts.robotoCondensed();

  @override
  TextStyle get kaitekiTextStyle {
    return GoogleFonts.quicksand(fontWeight: FontWeight.w600);
  }
}

extension ThemeExtensions on ThemeData {
  KaitekiTextTheme? get ktkTextTheme => extension<KaitekiTextTheme>();
}
