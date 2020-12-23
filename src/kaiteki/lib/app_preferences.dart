import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'app_preferences.g.dart';

@JsonSerializable()
class AppPreferences extends ChangeNotifier {
  ThemeMode theme = ThemeMode.dark;

  AppPreferences({
    this.theme,
  });

  void setTheme(ThemeMode value) {
    this.theme = value;
    notifyListeners();
  }

  factory AppPreferences.fromJson(Map<String, dynamic> json) =>
      _$AppPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$AppPreferencesToJson(this);
}
