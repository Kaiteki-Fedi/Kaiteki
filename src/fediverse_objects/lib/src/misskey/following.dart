import 'package:fediverse_objects/src/misskey/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'following.g.dart';

@JsonSerializable()
class Following {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'followeeId')
  final String followeeId;

  @JsonKey(name: 'followee')
  final User? followee;

  @JsonKey(name: 'followerId')
  final String followerId;

  @JsonKey(name: 'follower')
  final User? follower;

  const Following({
    required this.id,
    required this.createdAt,
    required this.followeeId,
    required this.followee,
    required this.followerId,
    required this.follower,
  });

  factory Following.fromJson(Map<String, dynamic> json) =>
      _$FollowingFromJson(json);

  Map<String, dynamic> toJson() => _$FollowingToJson(this);
}
