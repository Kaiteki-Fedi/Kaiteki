// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_v11.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyThemeV11 _$MisskeyThemeV11FromJson(Map<String, dynamic> json) {
  return MisskeyThemeV11(
    author: json['author'] as String,
    base: json['base'] as String,
    description: json['desc'] as String,
    id: json['id'] as String,
    name: json['name'] as String,
    variables: (json['vars'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
  );
}
