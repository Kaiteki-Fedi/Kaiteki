// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      isMuted: json['is_muted'] as bool,
      isSeen: json['is_seen'] as bool,
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'is_muted': instance.isMuted,
      'is_seen': instance.isSeen,
    };
