import "package:flutter/material.dart";

import "default/m3_color_schemes.dart" as kaiteki;

enum AppTheme {
  affection(Colors.red),
  joy(Colors.orange),
  comfort(Colors.amber),
  serenity(Colors.lightGreen),
  compassion(Colors.lightBlue),
  spirit(Colors.deepPurple),
  care(Colors.pink);

  final Color baseColor;

  const AppTheme(this.baseColor);

  ColorScheme getColorScheme(Brightness brightness) {
    // Here we're being cheeky and use Kaiteki's theme for red.
    if (this == AppTheme.affection) {
      return switch (brightness) {
        Brightness.dark => kaiteki.darkColorScheme,
        Brightness.light => kaiteki.lightColorScheme,
      };
    }

    return ColorScheme.fromSeed(seedColor: baseColor, brightness: brightness);
  }
}
