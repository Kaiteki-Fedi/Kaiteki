// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyNotification _$MisskeyNotificationFromJson(Map<String, dynamic> json) {
  return MisskeyNotification(
    id: json['id'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    type: json['type'] as String,
    userId: json['userId'] as String,
    user: MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MisskeyNotificationToJson(
        MisskeyNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'type': instance.type,
      'userId': instance.userId,
      'user': instance.user,
    };
