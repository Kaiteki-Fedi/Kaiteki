import 'package:flutter/material.dart';
import 'package:kaiteki/app_colors.dart';
import 'package:kaiteki/theming/app_themes/material_app_theme.dart';

const double rounding = 24.0;
const BorderRadius borderRadius = BorderRadius.all(
  Radius.circular(rounding),
);

final MaterialAppTheme lightAppTheme = MaterialAppTheme(
  ThemeData.from(colorScheme: lightScheme)._applyGeneralChanges(),
  linkTextStyle: TextStyle(color: kaitekiPink.shade700),
);

final ColorScheme lightScheme = ColorScheme.light(
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

final MaterialAppTheme darkAppTheme = MaterialAppTheme(
  ThemeData.from(colorScheme: darkScheme)._applyGeneralChanges(),
);

final ColorScheme darkScheme = ColorScheme.dark(
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

extension _ThemeDataExtensions on ThemeData {
  ThemeData _applyGeneralChanges() {
    return copyWith(
      snackBarTheme: const SnackBarThemeData(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: const DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),
    );
  }
}
