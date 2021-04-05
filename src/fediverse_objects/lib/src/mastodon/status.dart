import 'package:fediverse_objects/src/mastodon/account.dart';
import 'package:fediverse_objects/src/mastodon/application.dart';
import 'package:fediverse_objects/src/mastodon/attachment.dart';
import 'package:fediverse_objects/src/mastodon/card.dart';
import 'package:fediverse_objects/src/mastodon/emoji.dart';
import 'package:fediverse_objects/src/mastodon/mention.dart';
import 'package:fediverse_objects/src/mastodon/poll.dart';
import 'package:fediverse_objects/src/mastodon/tag.dart';
import 'package:fediverse_objects/src/pleroma/status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'status.g.dart';

@JsonSerializable()
class MastodonStatus {
  final MastodonAccount account;

  /// The application used to post this status.
  final MastodonApplication? application;

  /// Have you bookmarked this status?
  final bool? bookmarked;

  /// Preview card for links included within status content.
  final MastodonCard? card;

  final String content;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// Custom emoji to be used when rendering status content.
  final Iterable<MastodonEmoji> emojis;

  /// Have you favourited this status?
  final bool? favourited;

  /// How many favourites this status has received.
  @JsonKey(name: 'favourites_count')
  final int favouritesCount;

  final String id;

  /// ID of the account being replied to.
  @JsonKey(name: 'in_reply_to_account_id')
  final String? inReplyToAccountId;

  /// ID of the status being replied.
  @JsonKey(name: 'in_reply_to_id')
  final String? inReplyToId;

  /// Primary language of this status.
  final String? language;

  /// Media that is attached to this status.
  @JsonKey(name: 'media_attachments')
  final Iterable<MastodonAttachment> mediaAttachments;

  /// Mentions of users within the status content.
  final Iterable<MastodonMention> mentions;

  /// Have you muted notifications for this status's conversation?
  final bool? muted;

  /// Have you pinned this status?
  ///
  /// Only appears if the status is pinnable.
  final bool? pinned;

  final PleromaStatus? pleroma;

  /// The status being reblogged.
  final MastodonStatus? reblog;

  /// Have you boosted this status?
  final bool? reblogged;

  /// How many boosts this status has received.
  @JsonKey(name: 'reblogs_count')
  final int reblogsCount;

  /// How many replies this status has received.
  @JsonKey(name: 'replies_count')
  final int repliesCount;

  /// The poll attached to the status.
  final MastodonPoll? poll;

  /// Is this status marked as sensitive content?
  final bool sensitive;

  /// Subject or summary line, below which status content is collapsed until expanded.
  @JsonKey(name: 'spoiler_text')
  final String spoilerText;

  /// Hashtags used within the status content.
  final Iterable<MastodonTag> tags;

  final String uri;

  /// A link to the status's HTML representation.
  final String? url;

  /// Visibility of this status.
  ///
  /// - `public` = Visible to everyone, shown in public timelines.
  /// - `unlisted` = Visible to public, but not included in public timelines.
  /// - `private` = Visible to followers only, and to any mentioned users.
  /// - `direct` = Visible only to mentioned users.
  final String visibility;

  /// Plain-text source of a status.
  ///
  /// Returned instead of `content` when status is deleted, so the user may redraft from the source text without the client having to reverse-engineer the original text from the HTML content.
  final String? text;

  MastodonStatus({
    required this.account,
    this.application,
    required this.content,
    required this.createdAt,
    required this.emojis,
    required this.favouritesCount,
    required this.id,
    required this.mediaAttachments,
    required this.mentions,
    required this.reblogsCount,
    required this.repliesCount,
    required this.sensitive,
    required this.spoilerText,
    required this.tags,
    required this.uri,
    required this.visibility,
    this.bookmarked,
    this.card,
    this.favourited,
    this.inReplyToAccountId,
    this.inReplyToId,
    this.language,
    this.muted,
    this.pinned,
    this.pleroma,
    this.reblog,
    this.reblogged,
    this.url,
    this.text,
    this.poll,
  });

  factory MastodonStatus.fromJson(Map<String, dynamic> json) =>
      _$MastodonStatusFromJson(json);

  Map<String, dynamic> toJson() => _$MastodonStatusToJson(this);
}
