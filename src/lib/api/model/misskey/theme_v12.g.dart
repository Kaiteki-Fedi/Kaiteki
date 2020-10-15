// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_v12.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyThemeV12 _$MisskeyThemeV12FromJson(Map<String, dynamic> json) {
  return MisskeyThemeV12(
    author: json['author'] as String,
    base: json['base'] as String,
    description: json['desc'] as String,
    id: json['id'] as String,
    name: json['name'] as String,
    properties: (json['props'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
  );
}
