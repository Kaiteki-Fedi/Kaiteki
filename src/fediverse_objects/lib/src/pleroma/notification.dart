import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification {
  @JsonKey(name: 'is_muted')
  final bool isMuted;

  @JsonKey(name: 'is_seen')
  final bool isSeen;

  const Notification({
    required this.isMuted,
    required this.isSeen,
  });

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
