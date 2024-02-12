// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationSettings _$NotificationSettingsFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'NotificationSettings',
      json,
      ($checkedConvert) {
        final val = NotificationSettings(
          $checkedConvert('block_from_strangers', (v) => v as bool),
          $checkedConvert('hide_notification_contents', (v) => v as bool),
        );
        return val;
      },
      fieldKeyMap: const {
        'blockFromStrangers': 'block_from_strangers',
        'hideNotificationContents': 'hide_notification_contents'
      },
    );

Map<String, dynamic> _$NotificationSettingsToJson(
        NotificationSettings instance) =>
    <String, dynamic>{
      'block_from_strangers': instance.blockFromStrangers,
      'hide_notification_contents': instance.hideNotificationContents,
    };
