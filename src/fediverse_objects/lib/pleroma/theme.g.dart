// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaTheme _$PleromaThemeFromJson(Map<String, dynamic> json) {
  return PleromaTheme(
    themeEngineVersion: json['themeEngineVersion'] as int,
    shadows: (json['shadows'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          (e as List)?.map((e) => e == null
              ? null
              : PleromaThemeShadow.fromJson(e as Map<String, dynamic>))),
    ),
    colors: (json['colors'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    opacity: (json['opacity'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, (e as num)?.toDouble()),
    ),
    radii: (json['radii'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, (e as num)?.toDouble()),
    ),
    fonts: (json['fonts'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : PleromaThemeFont.fromJson(e as Map<String, dynamic>)),
    ),
  );
}

Map<String, dynamic> _$PleromaThemeToJson(PleromaTheme instance) =>
    <String, dynamic>{
      'themeEngineVersion': instance.themeEngineVersion,
      'shadows': instance.shadows?.map((k, e) => MapEntry(k, e?.toList())),
      'colors': instance.colors,
      'opacity': instance.opacity,
      'radii': instance.radii,
      'fonts': instance.fonts,
    };
