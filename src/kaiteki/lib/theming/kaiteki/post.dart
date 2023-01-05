import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

class KaitekiPostTheme extends ThemeExtension<KaitekiPostTheme> {
  final EdgeInsets padding;
  final double avatarSpacing;

  static const fallback = KaitekiPostTheme(
    padding: EdgeInsets.all(8),
    avatarSpacing: 8.0,
  );

  const KaitekiPostTheme({
    required this.padding,
    required this.avatarSpacing,
  });

  @override
  ThemeExtension<KaitekiPostTheme> copyWith({
    EdgeInsets? padding,
    double? avatarSpacing,
  }) {
    return KaitekiPostTheme(
      padding: padding ?? this.padding,
      avatarSpacing: avatarSpacing ?? this.avatarSpacing,
    );
  }

  @override
  KaitekiPostTheme lerp(ThemeExtension<KaitekiPostTheme>? other, double t) {
    if (other is! KaitekiPostTheme) return this;

    return KaitekiPostTheme(
      padding: EdgeInsets.lerp(padding, other.padding, t)!,
      avatarSpacing: lerpDouble(avatarSpacing, other.avatarSpacing, t)!,
    );
  }
}

extension ThemeExtensions on ThemeData {
  KaitekiPostTheme? get ktkPostTheme => extension<KaitekiPostTheme>();
}
