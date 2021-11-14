// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppPreferences _$AppPreferencesFromJson(Map<String, dynamic> json) =>
    AppPreferences(
      theme: $enumDecodeNullable(_$ThemeModeEnumMap, json['theme']) ??
          ThemeMode.system,
      sensitivePostFilter: json['sensitivePostFilter'],
    );

Map<String, dynamic> _$AppPreferencesToJson(AppPreferences instance) =>
    <String, dynamic>{
      'theme': _$ThemeModeEnumMap[instance.theme],
      'sensitivePostFilter': instance.sensitivePostFilter,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
