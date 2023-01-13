import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki/utils/utils.dart";

part "user.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  /// Unique identifier of this user.
  ///
  /// This is returned as a string in order to avoid complications with
  /// languages and tools that cannot handle large integers.
  final String id;

  /// The friendly name of this user, as shown on their profile.
  final String name;

  /// The Twitter handle (screen name) of this user.
  final String username;

  final DateTime? createdAt;

  final String? description;

  final String? url;
  final bool? verified;
  final String? location;
  final String? pinnedTweetId;
  final String? profileImageUrl;
  final UserPublicMetrics? publicMetrics;

  const User({
    required this.id,
    required this.name,
    required this.username,
    this.createdAt,
    this.description,
    this.url,
    this.verified,
    this.location,
    this.pinnedTweetId,
    this.profileImageUrl,
    this.publicMetrics,
  });

  factory User.fromJson(JsonMap json) => _$UserFromJson(json);

  JsonMap toJson() => _$UserToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UserPublicMetrics {
  final int? followersCount;
  final int? followingCount;
  final int? tweetCount;
  final int? listedCount;

  const UserPublicMetrics({
    required this.followersCount,
    required this.followingCount,
    required this.tweetCount,
    required this.listedCount,
  });

  factory UserPublicMetrics.fromJson(JsonMap json) =>
      _$UserPublicMetricsFromJson(json);

  JsonMap toJson() => _$UserPublicMetricsToJson(this);
}

typedef UserFields = Set<UserField>;

enum UserField {
  verified,
  createdAt,
  protected,
  url,
  location,
  description,
  profileImageUrl,
  publicMetrics,
  username,
  withheld,
  name,
  id,
  entities,
  pinnedTweetId;

  @override
  String toString() => this.name.snake;
}
