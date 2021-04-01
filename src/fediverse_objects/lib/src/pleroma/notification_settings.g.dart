// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaNotificationSettings _$PleromaNotificationSettingsFromJson(
    Map<String, dynamic> json) {
  return PleromaNotificationSettings(
    json['block_from_strangers'] as bool,
    json['hide_notification_contents'] as bool,
  );
}

Map<String, dynamic> _$PleromaNotificationSettingsToJson(
        PleromaNotificationSettings instance) =>
    <String, dynamic>{
      'block_from_strangers': instance.blockFromStrangers,
      'hide_notification_contents': instance.hideNotificationContents,
    };
