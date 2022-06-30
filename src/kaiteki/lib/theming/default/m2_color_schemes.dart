import 'package:flutter/material.dart';
import 'package:kaiteki/app_colors.dart';

final lightColorScheme = ColorScheme.light(
  background: kaitekiLightBackground.shade100,
  surface: kaitekiLightBackground.shade50,
  // primary
  primary: kaitekiPink.shade500,
  primaryContainer: kaitekiPink.shade700,
  // secondary
  secondary: kaitekiOrange.shade400,
  secondaryContainer: kaitekiOrange.shade600,
  // error
  error: Colors.red,
  onError: Colors.black,
);

final darkColorScheme = ColorScheme.dark(
  background: kaitekiDarkBackground.shade900,
  surface: kaitekiDarkBackground.shade800,
  // primary
  primary: kaitekiPink.shade200,
  primaryContainer: kaitekiPink.shade500,
  // secondary
  secondary: kaitekiPink.shade200,
  secondaryContainer: kaitekiPink.shade500,
  // error
  error: Colors.red,
);
