import 'package:flutter/material.dart';
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/theming/default/extensions.dart';
import 'package:kaiteki/theming/default/m2_color_schemes.dart' as m2;
import 'package:kaiteki/theming/default/m3_color_schemes.dart' as m3;

final ThemeData lightThemeData = ThemeData.from(
  colorScheme: lightScheme,
  useMaterial3: consts.useM3,
).applyGeneralChanges();

final ColorScheme lightScheme =
    consts.useM3 ? m3.lightColorScheme : m2.lightColorScheme;

final ThemeData darkThemeData = ThemeData.from(
  colorScheme: darkScheme,
  useMaterial3: consts.useM3,
).applyGeneralChanges();

final ColorScheme darkScheme =
    consts.useM3 ? m3.darkColorScheme : m2.darkColorScheme;
