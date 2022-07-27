import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

class KaitekiTextTheme extends ThemeExtension<KaitekiTextTheme> {
  final TextStyle hashtagTextStyle;
  final TextStyle linkTextStyle;
  final TextStyle mentionTextStyle;
  final double emojiScale;

  const KaitekiTextTheme({
    required this.hashtagTextStyle,
    required this.linkTextStyle,
    required this.mentionTextStyle,
    required this.emojiScale,
  });

  factory KaitekiTextTheme.fromMaterialTheme(ThemeData theme) {
    final accentTextStyle = TextStyle(color: theme.colorScheme.secondary);
    return KaitekiTextTheme(
      linkTextStyle: accentTextStyle,
      hashtagTextStyle: accentTextStyle,
      mentionTextStyle: accentTextStyle,
      emojiScale: 1.5,
    );
  }

  @override
  ThemeExtension<KaitekiTextTheme> copyWith({
    TextStyle? hashtagTextStyle,
    TextStyle? linkTextStyle,
    TextStyle? mentionTextStyle,
    double? emojiScale,
  }) {
    return KaitekiTextTheme(
      linkTextStyle: linkTextStyle ?? this.linkTextStyle,
      hashtagTextStyle: hashtagTextStyle ?? this.hashtagTextStyle,
      mentionTextStyle: mentionTextStyle ?? this.mentionTextStyle,
      emojiScale: emojiScale ?? this.emojiScale,
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
    );
  }
}

extension ThemeExtensions on ThemeData {
  KaitekiTextTheme? get ktkTextTheme => extension<KaitekiTextTheme>();
}
