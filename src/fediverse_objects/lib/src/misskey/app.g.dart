// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyApp _$MisskeyAppFromJson(Map<String, dynamic> json) {
  return MisskeyApp(
    id: json['id'] as String,
    name: json['name'] as String,
    createdAt: json['createdAt'] as String,
    lastUsedAt: json['lastUsedAt'] as String,
    permission: (json['permission'] as List)?.map((e) => e as String),
    secret: json['secret'] as String,
    isAuthorized: json['isAuthorized'] as bool,
  );
}

Map<String, dynamic> _$MisskeyAppToJson(MisskeyApp instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt,
      'lastUsedAt': instance.lastUsedAt,
      'permission': instance.permission?.toList(),
      'secret': instance.secret,
      'isAuthorized': instance.isAuthorized,
    };
