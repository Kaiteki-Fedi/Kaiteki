import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class PleromaNotification {
  @JsonKey(name: 'is_muted')
  final bool isMuted;

  @JsonKey(name: 'is_seen')
  final bool isSeen;

  const PleromaNotification({
    required this.isMuted,
    required this.isSeen,
  });

  factory PleromaNotification.fromJson(Map<String, dynamic> json) =>
      _$PleromaNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$PleromaNotificationToJson(this);
}
