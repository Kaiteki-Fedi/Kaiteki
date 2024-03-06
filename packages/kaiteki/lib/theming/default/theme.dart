import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff8e4955),
      surfaceTint: Color(0xff8e4955),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffd9dd),
      onPrimaryContainer: Color(0xff3b0714),
      secondary: Color(0xff76565a),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffd9dd),
      onSecondaryContainer: Color(0xff2c1518),
      tertiary: Color(0xff785831),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffddb8),
      onTertiaryContainer: Color(0xff2b1700),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff22191a),
      onSurfaceVariant: Color(0xff524344),
      outline: Color(0xff847374),
      outlineVariant: Color(0xffd7c1c3),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e2f),
      onInverseSurface: Color(0xfffeeded),
      inversePrimary: Color(0xffffb2bc),
      primaryFixed: Color(0xffffd9dd),
      onPrimaryFixed: Color(0xff3b0714),
      primaryFixedDim: Color(0xffffb2bc),
      onPrimaryFixedVariant: Color(0xff72333e),
      secondaryFixed: Color(0xffffd9dd),
      onSecondaryFixed: Color(0xff2c1518),
      secondaryFixedDim: Color(0xffe5bdc1),
      onSecondaryFixedVariant: Color(0xff5c3f43),
      tertiaryFixed: Color(0xffffddb8),
      onTertiaryFixed: Color(0xff2b1700),
      tertiaryFixedDim: Color(0xffeabf8f),
      onTertiaryFixedVariant: Color(0xff5e411c),
      surfaceDim: Color(0xffe7d6d7),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0f1),
      surfaceContainer: Color(0xfffbeaeb),
      surfaceContainerHigh: Color(0xfff6e4e5),
      surfaceContainerHighest: Color(0xfff0dedf),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff6d2f3a),
      surfaceTint: Color(0xff8e4955),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffa95f6a),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff583b3f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff8e6c70),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff5a3d18),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff916e45),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff22191a),
      onSurfaceVariant: Color(0xff4e3f41),
      outline: Color(0xff6b5b5d),
      outlineVariant: Color(0xff887678),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e2f),
      onInverseSurface: Color(0xfffeeded),
      inversePrimary: Color(0xffffb2bc),
      primaryFixed: Color(0xffa95f6a),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff8b4752),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff8e6c70),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff735457),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff916e45),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff76562f),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe7d6d7),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0f1),
      surfaceContainer: Color(0xfffbeaeb),
      surfaceContainerHigh: Color(0xfff6e4e5),
      surfaceContainerHighest: Color(0xfff0dedf),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff440e1a),
      surfaceTint: Color(0xff8e4955),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff6d2f3a),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff331b1f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff583b3f),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff341d00),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff5a3d18),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff2d2122),
      outline: Color(0xff4e3f41),
      outlineVariant: Color(0xff4e3f41),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e2f),
      onInverseSurface: Color(0xffffffff),
      inversePrimary: Color(0xffffe6e8),
      primaryFixed: Color(0xff6d2f3a),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff511924),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff583b3f),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff3f2629),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff5a3d18),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff402704),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe7d6d7),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0f1),
      surfaceContainer: Color(0xfffbeaeb),
      surfaceContainerHigh: Color(0xfff6e4e5),
      surfaceContainerHighest: Color(0xfff0dedf),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb2bc),
      surfaceTint: Color(0xffffb2bc),
      onPrimary: Color(0xff561d28),
      primaryContainer: Color(0xff72333e),
      onPrimaryContainer: Color(0xffffd9dd),
      secondary: Color(0xffe5bdc1),
      onSecondary: Color(0xff43292d),
      secondaryContainer: Color(0xff5c3f43),
      onSecondaryContainer: Color(0xffffd9dd),
      tertiary: Color(0xffeabf8f),
      onTertiary: Color(0xff452b07),
      tertiaryContainer: Color(0xff5e411c),
      onTertiaryContainer: Color(0xffffddb8),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff1a1112),
      onSurface: Color(0xfff0dedf),
      onSurfaceVariant: Color(0xffd7c1c3),
      outline: Color(0xff9f8c8e),
      outlineVariant: Color(0xff524344),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dedf),
      onInverseSurface: Color(0xff382e2f),
      inversePrimary: Color(0xff8e4955),
      primaryFixed: Color(0xffffd9dd),
      onPrimaryFixed: Color(0xff3b0714),
      primaryFixedDim: Color(0xffffb2bc),
      onPrimaryFixedVariant: Color(0xff72333e),
      secondaryFixed: Color(0xffffd9dd),
      onSecondaryFixed: Color(0xff2c1518),
      secondaryFixedDim: Color(0xffe5bdc1),
      onSecondaryFixedVariant: Color(0xff5c3f43),
      tertiaryFixed: Color(0xffffddb8),
      onTertiaryFixed: Color(0xff2b1700),
      tertiaryFixedDim: Color(0xffeabf8f),
      onTertiaryFixedVariant: Color(0xff5e411c),
      surfaceDim: Color(0xff1a1112),
      surfaceBright: Color(0xff413737),
      surfaceContainerLowest: Color(0xff140c0d),
      surfaceContainerLow: Color(0xff22191a),
      surfaceContainer: Color(0xff261d1e),
      surfaceContainerHigh: Color(0xff312828),
      surfaceContainerHighest: Color(0xff3d3233),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb8c1),
      surfaceTint: Color(0xffffb2bc),
      onPrimary: Color(0xff33030f),
      primaryContainer: Color(0xffc97a86),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffe9c1c5),
      onSecondary: Color(0xff261013),
      secondaryContainer: Color(0xffac888b),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffeec393),
      onTertiary: Color(0xff231300),
      tertiaryContainer: Color(0xffb08a5e),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1a1112),
      onSurface: Color(0xfffff9f9),
      onSurfaceVariant: Color(0xffdbc6c7),
      outline: Color(0xffb29ea0),
      outlineVariant: Color(0xff917f80),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dedf),
      onInverseSurface: Color(0xff312828),
      inversePrimary: Color(0xff73343f),
      primaryFixed: Color(0xffffd9dd),
      onPrimaryFixed: Color(0xff2c000a),
      primaryFixedDim: Color(0xffffb2bc),
      onPrimaryFixedVariant: Color(0xff5d222e),
      secondaryFixed: Color(0xffffd9dd),
      onSecondaryFixed: Color(0xff200b0e),
      secondaryFixedDim: Color(0xffe5bdc1),
      onSecondaryFixedVariant: Color(0xff4a2f32),
      tertiaryFixed: Color(0xffffddb8),
      onTertiaryFixed: Color(0xff1c0e00),
      tertiaryFixedDim: Color(0xffeabf8f),
      onTertiaryFixedVariant: Color(0xff4b310c),
      surfaceDim: Color(0xff1a1112),
      surfaceBright: Color(0xff413737),
      surfaceContainerLowest: Color(0xff140c0d),
      surfaceContainerLow: Color(0xff22191a),
      surfaceContainer: Color(0xff261d1e),
      surfaceContainerHigh: Color(0xff312828),
      surfaceContainerHighest: Color(0xff3d3233),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffff9f9),
      surfaceTint: Color(0xffffb2bc),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffb8c1),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffff9f9),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffe9c1c5),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffffaf7),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffeec393),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1a1112),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffff9f9),
      outline: Color(0xffdbc6c7),
      outlineVariant: Color(0xffdbc6c7),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dedf),
      onInverseSurface: Color(0xff000000),
      inversePrimary: Color(0xff4e1622),
      primaryFixed: Color(0xffffdfe2),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb8c1),
      onPrimaryFixedVariant: Color(0xff33030f),
      secondaryFixed: Color(0xffffdfe2),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffe9c1c5),
      onSecondaryFixedVariant: Color(0xff261013),
      tertiaryFixed: Color(0xffffe2c4),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffeec393),
      onTertiaryFixedVariant: Color(0xff231300),
      surfaceDim: Color(0xff1a1112),
      surfaceBright: Color(0xff413737),
      surfaceContainerLowest: Color(0xff140c0d),
      surfaceContainerLow: Color(0xff22191a),
      surfaceContainer: Color(0xff261d1e),
      surfaceContainerHigh: Color(0xff312828),
      surfaceContainerHighest: Color(0xff3d3233),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    // scaffoldBackgroundColor: colorScheme.background,
    // canvasColor: colorScheme.surface,
  );

  /// Favorite
  static const favorite = ExtendedColor(
    seed: Color(0xffff9800),
    value: Color(0xffff9653),
    light: ColorFamily(
      color: Color(0xff8c4f27),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffdbc9),
      onColorContainer: Color(0xff321200),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff8c4f27),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffdbc9),
      onColorContainer: Color(0xff321200),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff8c4f27),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffdbc9),
      onColorContainer: Color(0xff321200),
    ),
    dark: ColorFamily(
      color: Color(0xffffb68c),
      onColor: Color(0xff532200),
      colorContainer: Color(0xff6f3812),
      onColorContainer: Color(0xffffdbc9),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffffb68c),
      onColor: Color(0xff532200),
      colorContainer: Color(0xff6f3812),
      onColorContainer: Color(0xffffdbc9),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffffb68c),
      onColor: Color(0xff532200),
      colorContainer: Color(0xff6f3812),
      onColorContainer: Color(0xffffdbc9),
    ),
  );

  /// Bookmark
  static const bookmark = ExtendedColor(
    seed: Color(0xffe91e63),
    value: Color(0xffe91f60),
    light: ColorFamily(
      color: Color(0xff8e4955),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffd9dd),
      onColorContainer: Color(0xff3b0715),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff8e4955),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffd9dd),
      onColorContainer: Color(0xff3b0715),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff8e4955),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffd9dd),
      onColorContainer: Color(0xff3b0715),
    ),
    dark: ColorFamily(
      color: Color(0xffffb2bd),
      onColor: Color(0xff561d29),
      colorContainer: Color(0xff72333e),
      onColorContainer: Color(0xffffd9dd),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffffb2bd),
      onColor: Color(0xff561d29),
      colorContainer: Color(0xff72333e),
      onColorContainer: Color(0xffffd9dd),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffffb2bd),
      onColor: Color(0xff561d29),
      colorContainer: Color(0xff72333e),
      onColorContainer: Color(0xffffd9dd),
    ),
  );

  /// Repeat
  static const repeat = ExtendedColor(
    seed: Color(0xff4caf50),
    value: Color(0xff76aa2e),
    light: ColorFamily(
      color: Color(0xff4c662b),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffceeda3),
      onColorContainer: Color(0xff112000),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff4c662b),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffceeda3),
      onColorContainer: Color(0xff112000),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff4c662b),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffceeda3),
      onColorContainer: Color(0xff112000),
    ),
    dark: ColorFamily(
      color: Color(0xffb2d189),
      onColor: Color(0xff203600),
      colorContainer: Color(0xff364e15),
      onColorContainer: Color(0xffceeda3),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffb2d189),
      onColor: Color(0xff203600),
      colorContainer: Color(0xff364e15),
      onColorContainer: Color(0xffceeda3),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffb2d189),
      onColor: Color(0xff203600),
      colorContainer: Color(0xff364e15),
      onColorContainer: Color(0xffceeda3),
    ),
  );


  List<ExtendedColor> get extendedColors => [
    favorite,
    bookmark,
    repeat,
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
