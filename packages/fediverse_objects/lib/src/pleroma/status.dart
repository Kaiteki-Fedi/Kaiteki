import 'package:json_annotation/json_annotation.dart';

import '../mastodon/reaction.dart';

part 'status.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PleromaStatus {
  /// A map consisting of alternate representations of the `content` property
  /// with the key being it's mimetype. Currently the only alternate
  /// representation supported is `text/plain`
  final Map<String, String>? content;

  /// The thread identifier the status is associated with
  final String? context;

  /// The ID of the AP context the status is associated with (if any)
  @Deprecated("Use context instead.")
  final int? conversationId;

  /// The ID of the Mastodon direct message conversation the status is
  /// associated with (if any)
  final int? directConversationId;

  /// A list with emoji / reaction maps. Contains no information about the
  /// reacting users, for that use the /statuses/:id/reactions endpoint.
  final List<Reaction>? emojiReactions;

  /// A datetime (ISO 8601) that states when the post will expire (be deleted
  /// automatically), or empty if the post won't expire
  final DateTime? expiresAt;

  /// The `acct` property of User entity for replied user (if any)
  final String? inReplyToAccountAcct;

  /// `true` if the post was made on the local instance
  final bool local;

  /// `true` if the parent post is visible to the user
  final bool? parentVisible;

  /// A datetime (ISO 8601) that states when the post was pinned or `null` if
  /// the post is not pinned
  final DateTime? pinnedAt;

  /// A map consisting of alternate representations of the `spoiler_text`
  /// property with the key being it's mimetype. Currently the only alternate
  /// representation supported is `text/plain`.
  final Map<String, String>? spoilerText;

  /// `true` if the thread the post belongs to is muted
  final bool? threadMuted;

  const PleromaStatus({
    this.content,
    required this.context,
    this.conversationId,
    this.directConversationId,
    this.emojiReactions,
    this.expiresAt,
    this.inReplyToAccountAcct,
    required this.local,
    this.parentVisible,
    this.spoilerText,
    this.threadMuted,
    this.pinnedAt,
  });

  factory PleromaStatus.fromJson(Map<String, dynamic> json) =>
      _$PleromaStatusFromJson(json);

  Map<String, dynamic> toJson() => _$PleromaStatusToJson(this);
}
