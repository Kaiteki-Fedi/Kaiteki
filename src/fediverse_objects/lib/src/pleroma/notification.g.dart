// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaNotification _$PleromaNotificationFromJson(Map<String, dynamic> json) {
  return PleromaNotification(
    isMuted: json['is_muted'] as bool,
    isSeen: json['is_seen'] as bool,
  );
}

Map<String, dynamic> _$PleromaNotificationToJson(
        PleromaNotification instance) =>
    <String, dynamic>{
      'is_muted': instance.isMuted,
      'is_seen': instance.isSeen,
    };
