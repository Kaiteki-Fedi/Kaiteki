import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/constants.dart';
part 'app_preferences.g.dart';

@JsonSerializable()
class AppPreferences extends ChangeNotifier {
  ButtonPlacement submitButtonLocation = ButtonPlacement.AppBar;
  TextFieldSize textFieldSize = TextFieldSize.Mobile;
  NameMode appNameMode = NameMode.Romaji;
  bool atWorkMode = true;

  String getPreferredAppName() => Constants.getPreferredAppName(appNameMode);

  AppPreferences({
    this.submitButtonLocation,
    this.textFieldSize,
    this.appNameMode,
    this.atWorkMode,
  });

  factory AppPreferences.fromJson(Map<String, dynamic> json) => _$AppPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$AppPreferencesToJson(this);
}

enum TextFieldSize {
  Mobile,
  Desktop
}

enum NameMode {
  Romaji,
  Hiragana,
  Katakana,
  Kanji
}

enum ButtonPlacement {
  AppBar,
  Standalone
}