import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/preferences/sensitive_post_filtering_preferences.dart';
part 'app_preferences.g.dart';

// TODO: Make AppPreferences immutable, use copyWith(...) pattern.
@JsonSerializable(includeIfNull: false, createFactory: true, createToJson: true)
class AppPreferences {
  ThemeMode theme = ThemeMode.system;
  SensitivePostFilteringPreferences sensitivePostFilter =
      SensitivePostFilteringPreferences();

  AppPreferences({
    this.theme = ThemeMode.system,
    sensitivePostFilter,
  }) {
    this.sensitivePostFilter =
        sensitivePostFilter ?? SensitivePostFilteringPreferences();
  }

  factory AppPreferences.fromJson(Map<String, dynamic> json) =>
      _$AppPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$AppPreferencesToJson(this);
}
