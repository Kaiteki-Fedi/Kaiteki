import "package:copy_with_extension/copy_with_extension.dart";
import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki/utils/utils.dart";

part "tweet.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
@CopyWith()
class Tweet {
  final String id;
  final String text;

  /// The unique identifier of the User who posted this Tweet.
  final String? authorId;

  final TweetAttachments? attachments;
  final String? conversationId;
  final DateTime? createdAt;
  final String? inReplyToUserId;
  final String? lang;
  final TweetReplySettings? replySettings;
  final List<ReferencedTweet>? referencedTweets;
  final PublicMetrics? publicMetrics;
  final TweetEntities? entities;
  final String? source;

  const Tweet({
    required this.id,
    required this.text,
    this.authorId,
    this.conversationId,
    this.createdAt,
    this.inReplyToUserId,
    this.lang,
    this.replySettings,
    this.attachments,
    this.referencedTweets,
    this.publicMetrics,
    this.entities,
    this.source,
  });

  factory Tweet.fromJson(JsonMap json) => _$TweetFromJson(json);

  JsonMap toJson() => _$TweetToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TweetAttachments {
  final List<String>? pollIds;
  final List<String>? mediaKeys;

  const TweetAttachments({
    this.pollIds,
    this.mediaKeys,
  });

  factory TweetAttachments.fromJson(JsonMap json) =>
      _$TweetAttachmentsFromJson(json);

  JsonMap toJson() => _$TweetAttachmentsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ReferencedTweet {
  final ReferencedTweetType type;
  final String id;

  const ReferencedTweet(this.type, this.id);

  factory ReferencedTweet.fromJson(JsonMap json) =>
      _$ReferencedTweetFromJson(json);

  JsonMap toJson() => _$ReferencedTweetToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PublicMetrics {
  final int retweetCount;
  final int replyCount;
  final int likeCount;
  final int quoteCount;

  const PublicMetrics({
    required this.retweetCount,
    required this.replyCount,
    required this.likeCount,
    required this.quoteCount,
  });

  factory PublicMetrics.fromJson(JsonMap json) => _$PublicMetricsFromJson(json);

  JsonMap toJson() => _$PublicMetricsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TweetEntities {
  final List<TweetAnnotation>? annotations;
  final List<TweetTag>? hashtags;
  final List<TweetTag>? cashtags;
  final List<TweetUrl>? urls;

  const TweetEntities({
    this.annotations,
    this.hashtags,
    this.cashtags,
    this.urls,
  });

  factory TweetEntities.fromJson(JsonMap json) => _$TweetEntitiesFromJson(json);

  JsonMap toJson() => _$TweetEntitiesToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TweetEntity {
  final int start;
  final int end;

  const TweetEntity({required this.start, required this.end});

  factory TweetEntity.fromJson(JsonMap json) => _$TweetEntityFromJson(json);

  JsonMap toJson() => _$TweetEntityToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TweetAnnotation extends TweetEntity {
  final double probability;
  final String type;
  final String normalizedText;

  const TweetAnnotation({
    required super.start,
    required super.end,
    required this.probability,
    required this.type,
    required this.normalizedText,
  });

  factory TweetAnnotation.fromJson(JsonMap json) =>
      _$TweetAnnotationFromJson(json);

  @override
  JsonMap toJson() => _$TweetAnnotationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TweetTag extends TweetEntity {
  final String tag;

  const TweetTag({required super.start, required super.end, required this.tag});

  factory TweetTag.fromJson(JsonMap json) => _$TweetTagFromJson(json);

  @override
  JsonMap toJson() => _$TweetTagToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TweetUrl extends TweetEntity {
  final String url;
  final String expandedUrl;
  final String displayUrl;
  final String? unwoundUrl;
  final int? status;
  final String? title;
  final String? description;

  const TweetUrl({
    required super.start,
    required super.end,
    required this.url,
    required this.expandedUrl,
    required this.displayUrl,
    this.unwoundUrl,
    required this.status,
    required this.title,
    required this.description,
  });

  factory TweetUrl.fromJson(JsonMap json) => _$TweetUrlFromJson(json);

  @override
  JsonMap toJson() => _$TweetUrlToJson(this);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum ReferencedTweetType { repliedTo, quoted, retweeted }

typedef TweetFields = Set<TweetField>;

enum TweetField {
  createdAt,
  publicMetrics,
  withheld,
  id,
  entities,
  source,
  referencedTweets,
  possiblySensitive,
  lang,
  inReplyToUserId,
  geo,
  conversationId,
  contextAnnotations,
  attachments;

  @override
  String toString() => name.snake;
}

@JsonEnum(fieldRename: FieldRename.snake)
enum TweetReplySettings {
  everyone,
  mentionedUsers,
  followers,
}
