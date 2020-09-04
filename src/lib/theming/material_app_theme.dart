import 'package:flutter/material.dart';
import 'package:kaiteki/theming/app_theme.dart';
import 'package:kaiteki/theming/app_theme_convertible.dart';

class MaterialAppTheme implements AppThemeConvertible {
  final ThemeData materialTheme;

  const MaterialAppTheme(this.materialTheme);

  @override
  AppTheme toTheme() => AppTheme.fromMaterialTheme(materialTheme);
}