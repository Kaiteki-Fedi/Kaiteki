import "package:flutter/material.dart";
import "package:kaiteki/theming/default/colors.dart";

final lightColorScheme = ColorScheme.light(
  background: Colors.grey.shade100,
  // primary
  primary: kaitekiPink.shade500,
  primaryContainer: kaitekiPink.shade700,
  // secondary
  secondary: kaitekiOrange.shade400,
  secondaryContainer: kaitekiOrange.shade600,
  // error
  error: Colors.red,
);

// based on https://m2.material.io/design/color/dark-theme.html
final darkColorScheme = ColorScheme.dark(
  background: Color.alphaBlend(
    kaitekiPink.withOpacity(.08),
    const Color(0xFF121212),
  ),
  surface: Color.alphaBlend(
    kaitekiPink.withOpacity(.08),
    const Color(0xFF121212),
  ),
  // primary
  primary: kaitekiPink.shade200,
  primaryContainer: kaitekiPink.shade700,
  // secondary
  secondary: kaitekiPink.shade200,
  secondaryContainer: kaitekiPink.shade200,
  // error
  error: Color.alphaBlend(
    Colors.white.withOpacity(.4),
    Colors.red,
  ),
);
