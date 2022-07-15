import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/theming/default/constants.dart';
import 'package:kaiteki/theming/kaiteki_extension.dart';

extension ThemeDataExtensions on ThemeData {
  ThemeData applyGeneralChanges() {
    return copyWith(
      snackBarTheme: const SnackBarThemeData(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: const DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),
      extensions: [KaitekiExtension.material(this)],
      textTheme: createKaitekiTextTheme(textTheme),
      checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all(colorScheme.surface),
        fillColor: MaterialStateProperty.resolveWith(
          (s) => s.contains(MaterialState.selected)
              ? colorScheme.secondary
              : colorScheme.onBackground.withOpacity(.87),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      ),
    );
  }
}

TextTheme createKaitekiTextTheme(TextTheme original) {
  return GoogleFonts.robotoTextTheme(original).copyWith(
    titleLarge: GoogleFonts.quicksand(
      textStyle: original.titleLarge,
      fontWeight: FontWeight.w600,
    ),
  );
}
