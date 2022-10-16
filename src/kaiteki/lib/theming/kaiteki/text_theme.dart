import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KaitekiTextTheme extends ThemeExtension<KaitekiTextTheme> {
  /// Text style used for hashtags.
  final TextStyle hashtagTextStyle;

  /// Text style used for links.
  final TextStyle linkTextStyle;

  /// Text style used for mentions.
  final TextStyle mentionTextStyle;

  final TextStyle monospaceTextStyle;

  /// Text style used for numbers.
  final TextStyle countTextStyle;

  /// Brand text style used for the Kaiteki logo.
  final TextStyle kaitekiTextStyle;

  /// Emoji scale relative to the current text.
  final double emojiScale;

  const KaitekiTextTheme({
    required this.hashtagTextStyle,
    required this.linkTextStyle,
    required this.mentionTextStyle,
    required this.emojiScale,
    required this.monospaceTextStyle,
    required this.countTextStyle,
    required this.kaitekiTextStyle,
  });

  factory KaitekiTextTheme.fromMaterialTheme(ThemeData theme) {
    final accentTextStyle = TextStyle(color: theme.colorScheme.secondary);
    return KaitekiTextTheme(
      linkTextStyle: accentTextStyle,
      hashtagTextStyle: accentTextStyle,
      mentionTextStyle: accentTextStyle,
      monospaceTextStyle: GoogleFonts.robotoMono(),
      emojiScale: 1.5,
      countTextStyle: GoogleFonts.robotoCondensed(),
      kaitekiTextStyle: GoogleFonts.quicksand(
        fontWeight: FontWeight.w600,
      ),
    );
  }

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
      emojiScale: emojiScale ?? this.emojiScale,
      countTextStyle: countTextStyle ?? this.countTextStyle,
      kaitekiTextStyle: kaitekiTextStyle ?? this.kaitekiTextStyle,
    );
  }

  @override
  KaitekiTextTheme lerp(ThemeExtension<KaitekiTextTheme>? other, double t) {
    if (other is! KaitekiTextTheme) return this;

    return KaitekiTextTheme(
      linkTextStyle: TextStyle.lerp(linkTextStyle, other.linkTextStyle, t)!,
      hashtagTextStyle: TextStyle.lerp(
        hashtagTextStyle,
        other.hashtagTextStyle,
        t,
      )!,
      mentionTextStyle: TextStyle.lerp(
        mentionTextStyle,
        other.mentionTextStyle,
        t,
      )!,
      emojiScale: lerpDouble(emojiScale, other.emojiScale, t)!,
      monospaceTextStyle: TextStyle.lerp(
        monospaceTextStyle,
        other.monospaceTextStyle,
        t,
      )!,
      countTextStyle: TextStyle.lerp(
        countTextStyle,
        other.countTextStyle,
        t,
      )!,
      kaitekiTextStyle: TextStyle.lerp(
        kaitekiTextStyle,
        other.kaitekiTextStyle,
        t,
      )!,
    );
  }
}

extension ThemeExtensions on ThemeData {
  KaitekiTextTheme? get ktkTextTheme => extension<KaitekiTextTheme>();
}
