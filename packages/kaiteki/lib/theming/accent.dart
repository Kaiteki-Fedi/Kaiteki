import "package:flutter/material.dart";

enum AppAccent {
  system,
  affection(Colors.red),
  joy(Colors.orange),
  comfort(Colors.amber),
  serenity(Colors.lightGreen),
  compassion(Colors.lightBlue),
  spirit(Colors.deepPurple),
  care(Colors.pink);

  final Color? baseColor;

  const AppAccent([this.baseColor]);

  ColorScheme? getColorScheme(Brightness brightness) {
    final baseColor = this.baseColor;

    if (baseColor == null) return null;

    return ColorScheme.fromSeed(seedColor: baseColor, brightness: brightness);
  }
}
