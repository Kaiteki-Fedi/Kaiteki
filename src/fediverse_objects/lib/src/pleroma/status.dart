import 'package:fediverse_objects/src/pleroma/emoji_reaction.dart';
import 'package:json_annotation/json_annotation.dart';

part 'status.g.dart';

@JsonSerializable()
class PleromaStatus {
  final Map<String, String>? content;

  @JsonKey(name: 'conversation_id')
  final int? conversationId;

  //@JsonKey(name: "direct_conversation_id")
  //final dynamic directConversationId;

  @JsonKey(name: 'emoji_reactions')
  final Iterable<PleromaEmojiReaction>? emojiReactions;

  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;

  @JsonKey(name: 'in_reply_to_account_acct')
  final String? inReplyToAccountAcct;

  final bool local;

  @JsonKey(name: 'parent_visible')
  final bool? parentVisible;

  // TODO: Introduce mimetype/text dictionary for rich content in Pleroma
  @JsonKey(name: "spoiler_text")
  final Map<String, String>? spoilerText;

  @JsonKey(name: 'thread_muted')
  final bool? threadMuted;

  const PleromaStatus(
    this.content,
    this.conversationId,
    //this.directConversationId,
    this.emojiReactions,
    this.expiresAt,
    this.inReplyToAccountAcct,
    this.local,
    this.parentVisible,
    this.spoilerText,
    this.threadMuted,
  );

  factory PleromaStatus.fromJson(Map<String, dynamic> json) =>
      _$PleromaStatusFromJson(json);

  Map<String, dynamic> toJson() => _$PleromaStatusToJson(this);
}
