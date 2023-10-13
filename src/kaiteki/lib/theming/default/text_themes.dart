import "package:flutter/material.dart";

/// Builds Kaiteki's default text theme.
TextTheme getTextTheme(TextTheme base) {
  final titleLarge = base.titleLarge ?? const TextStyle();

  final labelMedium = base.labelMedium ?? const TextStyle();
  final labelSmall = base.labelSmall ?? const TextStyle();

  const kFsec = "Fira Sans Extra Condensed";
  var textTheme = base.apply(fontFamily: "Fira Sans");
  return textTheme.copyWith(
    titleLarge: titleLarge.copyWith(
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w700,
    ),
    labelMedium: labelMedium.copyWith(fontFamily: kFsec),
    labelSmall: labelSmall.copyWith(fontFamily: kFsec),
  );
}
