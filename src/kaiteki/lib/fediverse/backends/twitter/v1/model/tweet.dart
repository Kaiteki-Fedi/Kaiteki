import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/fediverse/backends/twitter/v1/model/date_format.dart';
import 'package:kaiteki/fediverse/backends/twitter/v1/model/entities/entities.dart';
import 'package:kaiteki/fediverse/backends/twitter/v1/model/user.dart';

part 'tweet.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Tweet {
  @JsonKey(name: "created_at")
  final String createdAtStr;

  @JsonKey(ignore: true)
  DateTime get createdAt => twitterDateFormat.parse(createdAtStr);

  final bool favorited;
  final bool retweeted;
  final Entities entities;
  final int favoriteCount;
  final int retweetCount;
  final String idStr;
  final String? inReplyToStatusIdStr;
  final String? inReplyToUserIdStr;
  final String lang;
  final String text;
  final Tweet? quotedStatus;
  final Tweet? retweetedStatus;
  final User user;

  const Tweet({
    required this.createdAtStr,
    required this.entities,
    required this.favoriteCount,
    required this.favorited,
    required this.idStr,
    required this.inReplyToStatusIdStr,
    required this.inReplyToUserIdStr,
    required this.lang,
    required this.quotedStatus,
    required this.retweetCount,
    required this.retweeted,
    required this.text,
    required this.user,
    this.retweetedStatus,
  });

  factory Tweet.fromJson(Map<String, dynamic> json) => _$TweetFromJson(json);

  Map<String, dynamic> toJson() => _$TweetToJson(this);
}
