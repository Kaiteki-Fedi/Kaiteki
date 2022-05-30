import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/app_colors.dart';
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/theming/app_themes/material_app_theme.dart';
import 'package:kaiteki/theming/kaiteki_extension.dart';

final Color _seedColor = kaitekiPink.shade500;

const double rounding = 12.0;
const BorderRadius borderRadius = BorderRadius.all(
  Radius.circular(rounding),
);

final ThemeData lightThemeData = ThemeData.from(
  colorScheme: lightScheme,
  useMaterial3: consts.useM3,
)._applyGeneralChanges();

final MaterialAppTheme lightAppTheme = MaterialAppTheme(
  lightThemeData,
  linkTextStyle: TextStyle(color: kaitekiPink.shade700),
);

final ColorScheme lightScheme = consts.useM3
    ? ColorScheme.fromSeed(seedColor: _seedColor)
    : ColorScheme.light(
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

final ThemeData darkThemeData = ThemeData.from(
  colorScheme: darkScheme,
  useMaterial3: consts.useM3,
)._applyGeneralChanges();

final MaterialAppTheme darkAppTheme = MaterialAppTheme(darkThemeData);

final ColorScheme darkScheme = consts.useM3
    ? ColorScheme.fromSeed(seedColor: _seedColor, brightness: Brightness.dark)
    : ColorScheme.dark(
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
      extensions: [KaitekiExtension.material(this)],
      // textTheme:GoogleFonts.robotoTextTheme().copyWith(
      //   caption: const TextStyle(letterSpacing: 0),
      // ),
    );
  }
}
