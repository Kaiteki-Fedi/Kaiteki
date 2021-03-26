import 'package:json_annotation/json_annotation.dart';
part 'notification_settings.g.dart';

@JsonSerializable()
class PleromaNotificationSettings {
  @JsonKey(name: 'block_from_strangers')
  final bool blockFromStrangers;

  @JsonKey(name: 'hide_notification_contents')
  final bool hideNotificationContents;

  const PleromaNotificationSettings(
    this.blockFromStrangers,
    this.hideNotificationContents,
  );

  factory PleromaNotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$PleromaNotificationSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$PleromaNotificationSettingsToJson(this);
}
