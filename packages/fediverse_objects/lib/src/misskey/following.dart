import 'package:json_annotation/json_annotation.dart';

part 'following.g.dart';

@JsonSerializable()
class Following {
  final String id;

  final DateTime createdAt;

  final String followeeId;

  final dynamic followee;

  final String followerId;

  final dynamic follower;

  const Following({
    required this.id,
    required this.createdAt,
    required this.followeeId,
    this.followee,
    required this.followerId,
    this.follower,
  });

  factory Following.fromJson(Map<String, dynamic> json) =>
      _$FollowingFromJson(json);
  Map<String, dynamic> toJson() => _$FollowingToJson(this);
}
