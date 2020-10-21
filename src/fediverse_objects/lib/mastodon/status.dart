import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/pleroma/status.dart';
import 'package:fediverse_objects/mastodon/account.dart';
import 'package:fediverse_objects/mastodon/application.dart';
import 'package:fediverse_objects/mastodon/card.dart';
import 'package:fediverse_objects/mastodon/emoji.dart';
import 'package:fediverse_objects/mastodon/media_attachment.dart';
import 'package:fediverse_objects/mastodon/mention.dart';
import 'package:fediverse_objects/mastodon/tag.dart';
part 'status.g.dart';

@JsonSerializable(createToJson: false)
class MastodonStatus {
  final MastodonAccount account;

  final MastodonApplication application;

  final bool bookmarked;

  final MastodonCard card;

  final String content;

  @JsonKey(name: "created_at")
  final DateTime createdAt;

  final Iterable<MastodonEmoji> emojis;

  final bool favourited;

  @JsonKey(name: "favourites_count")
  final int favouritesCount;

  final String id;

  @JsonKey(name: "in_reply_to_account_id")
  final String inReplyToAccountId;

  @JsonKey(name: "in_reply_to_id")
  final String inReplyToId;

  final String language;

  @JsonKey(name: "media_attachments")
  final Iterable<MastodonMediaAttachment> mediaAttachments;

  final Iterable<MastodonMention> mentions;

  final bool muted;

  final bool pinned;

  final PleromaStatus pleroma;

  final MastodonStatus reblog;

  final bool reblogged;

  @JsonKey(name: "reblogs_count")
  final int reblogsCount;

  @JsonKey(name: "replies_count")
  final int repliesCount;

  final bool sensitive;

  @JsonKey(name: "spoiler_text")
  final String spoilerText;

  final Iterable<MastodonTag> tags;

  final String uri;

  final String url;

  final String visibility;

  const MastodonStatus({
    this.account,
    this.application,
    this.bookmarked,
    this.card,
    this.content,
    this.createdAt,
    this.emojis,
    this.favourited,
    this.favouritesCount,
    this.id,
    this.inReplyToAccountId,
    this.inReplyToId,
    this.language,
    this.mediaAttachments,
    this.mentions,
    this.muted,
    this.pinned,
    this.pleroma,
    this.reblog,
    this.reblogged,
    this.reblogsCount,
    this.repliesCount,
    this.sensitive,
    this.spoilerText,
    this.tags,
    this.uri,
    this.url,
    this.visibility,
  });

  factory MastodonStatus.fromJson(Map<String, dynamic> json) =>
      _$MastodonStatusFromJson(json);
}
