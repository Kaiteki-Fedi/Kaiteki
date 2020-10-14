import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/api/model/mastodon/card.dart';
import 'package:kaiteki/api/model/mastodon/emoji.dart';
import 'package:kaiteki/api/model/mastodon/media_attachment.dart';
part 'chat_message.g.dart';

@JsonSerializable()
class PleromaChatMessage {
  @JsonKey(name: "account_id")
  final String accountId;

  final MastodonMediaAttachment attachment;

  final MastodonCard card;

  @JsonKey(name: "chat_id")
  final String chatId;

  final String content;

  @JsonKey(name: "created_at")
  final DateTime createdAt;

  final Iterable<MastodonEmoji> emojis;

  final String id;

  const PleromaChatMessage({
    this.accountId,
    this.attachment,
    this.card,
    this.chatId,
    this.content,
    this.createdAt,
    this.emojis,
    this.id,
  });

  factory PleromaChatMessage.fromJson(Map<String, dynamic> json) => _$PleromaChatMessageFromJson(json);
}