// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationSettings _$NotificationSettingsFromJson(
        Map<String, dynamic> json) =>
    NotificationSettings(
      json['block_from_strangers'] as bool,
      json['hide_notification_contents'] as bool,
    );

Map<String, dynamic> _$NotificationSettingsToJson(
        NotificationSettings instance) =>
    <String, dynamic>{
      'block_from_strangers': instance.blockFromStrangers,
      'hide_notification_contents': instance.hideNotificationContents,
    };
