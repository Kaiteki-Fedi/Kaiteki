// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyClip _$MisskeyClipFromJson(Map<String, dynamic> json) {
  return MisskeyClip(
    id: json['id'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    userId: json['userId'] as String,
    user: MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
    name: json['name'] as String,
    description: json['description'] as String,
    isPublic: json['isPublic'] as bool,
  );
}

Map<String, dynamic> _$MisskeyClipToJson(MisskeyClip instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'userId': instance.userId,
      'user': instance.user,
      'name': instance.name,
      'description': instance.description,
      'isPublic': instance.isPublic,
    };
