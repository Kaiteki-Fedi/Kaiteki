// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaNotification _$PleromaNotificationFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PleromaNotification',
      json,
      ($checkedConvert) {
        final val = PleromaNotification(
          isMuted: $checkedConvert('is_muted', (v) => v as bool),
          isSeen: $checkedConvert('is_seen', (v) => v as bool),
        );
        return val;
      },
      fieldKeyMap: const {'isMuted': 'is_muted', 'isSeen': 'is_seen'},
    );

Map<String, dynamic> _$PleromaNotificationToJson(
        PleromaNotification instance) =>
    <String, dynamic>{
      'is_muted': instance.isMuted,
      'is_seen': instance.isSeen,
    };
