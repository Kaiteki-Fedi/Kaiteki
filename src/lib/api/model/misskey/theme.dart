import 'package:flutter/material.dart';
import 'package:kaiteki/theming/material_theme_convertible.dart';

class MisskeyTheme extends MaterialThemeConvertible {
  String name;
  String author;
  String desc;
  String base;
  Map<String, String> vars;
  String id;

  MisskeyTheme.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    author = json["author"];
    desc = json["desc"];
    base = json["base"];
    vars = json["vars"].cast<String, String>();
    id = json["id"];
  }

  @override
  ThemeData toMaterialTheme() {
    // TODO: implement toMaterialTheme
    throw UnimplementedError();
  }
}