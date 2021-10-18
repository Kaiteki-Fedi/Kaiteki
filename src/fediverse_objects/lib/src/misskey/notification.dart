import 'package:fediverse_objects/src/misskey/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification {
  /// The unique identifier for this notification.
  @JsonKey(name: 'id')
  final String id;

  /// The date that the notification was created.
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  /// The type of the notification.
  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'userId')
  final String userId;

  @JsonKey(name: 'user')
  final User user;

  const Notification({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.userId,
    required this.user,
  });

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
