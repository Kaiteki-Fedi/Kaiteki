import 'package:kaiteki/theming/app_theme.dart';
import 'package:kaiteki/theming/app_theme_convertible.dart';

// TODO: add property calculation
class MisskeyTheme extends AppThemeConvertible {
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

  @override
  AppTheme toTheme() {
    // TODO: implement toTheme
    throw UnimplementedError();
  }
}