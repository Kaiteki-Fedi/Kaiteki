import 'package:flutter/material.dart';
import 'package:kaiteki/theming/material_theme_convertible.dart';

class MisskeyTheme extends MaterialThemeConvertible {
  String name;
  String author;
  String desc;
  String base;
  Map<String, String> vars;
  Map<String, String> props;
  String id;

  MisskeyTheme.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    author = json["author"];
    desc = json["desc"];
    base = json["base"];
    vars = json["vars"].cast<String, String>();
    vars = json["props"].cast<String, String>();
    id = json["id"];
  }

  // TODO: add property calculation
  @override
  ThemeData toMaterialTheme() {
    // TODO: implement toMaterialTheme
    throw UnimplementedError();
  }
}