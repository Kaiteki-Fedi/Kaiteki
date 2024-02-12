import 'package:json_annotation/json_annotation.dart';

part 'notification_settings.g.dart';

@JsonSerializable()
class NotificationSettings {
  @JsonKey(name: 'block_from_strangers')
  final bool blockFromStrangers;

  @JsonKey(name: 'hide_notification_contents')
  final bool hideNotificationContents;

  const NotificationSettings(
    this.blockFromStrangers,
    this.hideNotificationContents,
  );

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationSettingsToJson(this);
}
