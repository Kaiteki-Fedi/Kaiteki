import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/theming/default/constants.dart';
import 'package:kaiteki/theming/kaiteki/colors.dart';
import 'package:kaiteki/theming/kaiteki/post.dart';
import 'package:kaiteki/theming/kaiteki/text_theme.dart';
import 'package:kaiteki/theming/kaiteki/theme.dart';
import 'package:kaiteki/ui/rounded_underline_tab_indicator.dart';

extension ThemeDataExtensions on ThemeData {
  ThemeData applyGeneralChanges() {
    final ktkTextTheme = KaitekiTextTheme.fromMaterialTheme(this);

    return copyWith(
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondaryContainer,
      ),
      snackBarTheme: const SnackBarThemeData(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: const DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),
      extensions: [
        ktkTextTheme,
        KaitekiColors.fromMaterialTheme(this),
        KaitekiTheme.fromMaterialTheme(this),
        KaitekiPostTheme.fallback,
      ],
      tabBarTheme: TabBarTheme(
        indicator: RoundedUnderlineTabIndicator(
          borderSide: BorderSide(width: 3, color: colorScheme.primary),
        ),
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
      ),
      textTheme: _createKaitekiTextTheme(textTheme, ktkTextTheme),
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

TextTheme _createKaitekiTextTheme(
  TextTheme original,
  KaitekiTextTheme ktkTextTheme,
) {
  final baseTextTheme = GoogleFonts.robotoTextTheme(original);
  return baseTextTheme.copyWith(
    titleLarge: ktkTextTheme.kaitekiTextStyle.copyWith(
      fontSize: baseTextTheme.titleLarge?.fontSize,
      color: baseTextTheme.titleLarge?.color,
    ),
  );
}
