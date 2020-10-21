import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/misskey/user.dart';
part 'notification.g.dart';

@JsonSerializable(createToJson: false)
class MisskeyNotification {
  final String id;

  final DateTime createdAt;

  // [ follow, followRequestAccepted, receiveFollowRequest, mention, reply,
  //   renote, quote, reaction, pollVote                                    ]
  final String type;

  final String userId;

  final MisskeyUser user;

  const MisskeyNotification({
    this.id,
    this.createdAt,
    this.type,
    this.user,
    this.userId,
  });

  factory MisskeyNotification.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNotificationFromJson(json);
}
