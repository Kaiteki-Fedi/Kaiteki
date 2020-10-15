// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppPreferences _$AppPreferencesFromJson(Map<String, dynamic> json) {
  return AppPreferences(
    submitButtonLocation: _$enumDecodeNullable(
        _$ButtonPlacementEnumMap, json['submitButtonLocation']),
    textFieldSize:
        _$enumDecodeNullable(_$TextFieldSizeEnumMap, json['textFieldSize']),
    appNameMode: _$enumDecodeNullable(_$NameModeEnumMap, json['appNameMode']),
    atWorkMode: json['atWorkMode'] as bool,
  );
}

Map<String, dynamic> _$AppPreferencesToJson(AppPreferences instance) =>
    <String, dynamic>{
      'submitButtonLocation':
          _$ButtonPlacementEnumMap[instance.submitButtonLocation],
      'textFieldSize': _$TextFieldSizeEnumMap[instance.textFieldSize],
      'appNameMode': _$NameModeEnumMap[instance.appNameMode],
      'atWorkMode': instance.atWorkMode,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ButtonPlacementEnumMap = {
  ButtonPlacement.AppBar: 'AppBar',
  ButtonPlacement.Standalone: 'Standalone',
};

const _$TextFieldSizeEnumMap = {
  TextFieldSize.Mobile: 'Mobile',
  TextFieldSize.Desktop: 'Desktop',
};

const _$NameModeEnumMap = {
  NameMode.Romaji: 'Romaji',
  NameMode.Hiragana: 'Hiragana',
  NameMode.Katakana: 'Katakana',
  NameMode.Kanji: 'Kanji',
};
