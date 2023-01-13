import "package:fediverse_objects/misskey.dart";
import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/utils/utils.dart";

part "follow.g.dart";

@JsonSerializable()
class MisskeyFollow {
  final String id;
  final DateTime createdAt;
  final String followeeId;
  final User? followee;
  final String followerId;
  final User? follower;

  const MisskeyFollow({
    required this.id,
    required this.createdAt,
    required this.followeeId,
    this.followee,
    required this.followerId,
    this.follower,
  });

  factory MisskeyFollow.fromJson(JsonMap json) => _$MisskeyFollowFromJson(json);

  JsonMap toJson() => _$MisskeyFollowToJson(this);
}
