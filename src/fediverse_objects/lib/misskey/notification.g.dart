// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyNotification _$MisskeyNotificationFromJson(Map<String, dynamic> json) {
  return MisskeyNotification(
    id: json['id'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    type: json['type'] as String,
    user: json['user'] == null
        ? null
        : MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
    userId: json['userId'] as String,
  );
}
