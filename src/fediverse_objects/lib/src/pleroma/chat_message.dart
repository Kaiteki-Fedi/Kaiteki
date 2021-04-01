import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/src/mastodon/card.dart';
import 'package:fediverse_objects/src/mastodon/emoji.dart';
import 'package:fediverse_objects/src/mastodon/attachment.dart';
part 'chat_message.g.dart';

@JsonSerializable()
class PleromaChatMessage {
  /// The Mastodon API id of the actor
  @JsonKey(name: 'account_id')
  final String accountId;

  final MastodonAttachment? attachment;

  /// Preview card for links included within status content
  final MastodonCard? card;

  @JsonKey(name: 'chat_id')
  final String chatId;

  final String? content;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  final Iterable<MastodonEmoji> emojis;

  final String id;

  /// Whether a message has been marked as read.
  final bool unread;

  const PleromaChatMessage({
    required this.accountId,
    required this.chatId,
    required this.createdAt,
    required this.emojis,
    required this.id,
    required this.unread,
    this.attachment,
    this.card,
    this.content,
  });

  factory PleromaChatMessage.fromJson(Map<String, dynamic> json) =>
      _$PleromaChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$PleromaChatMessageToJson(this);
}
