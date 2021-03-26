import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/src/misskey/user.dart';
part 'notification.g.dart';

@JsonSerializable()
class MisskeyNotification {
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
  final MisskeyUser user;
  
  const MisskeyNotification({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.userId,
    required this.user,
  });

  factory MisskeyNotification.fromJson(Map<String, dynamic> json) => _$MisskeyNotificationFromJson(json);
  Map<String, dynamic> toJson() => _$MisskeyNotificationToJson(this);
}
