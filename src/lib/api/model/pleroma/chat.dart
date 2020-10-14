import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/api/model/mastodon/account.dart';
import 'package:kaiteki/api/model/pleroma/chat_message.dart';
part 'chat.g.dart';

@JsonSerializable()
class PleromaChat {
  final MastodonAccount account;

  final String id;

  @JsonKey(name: "last_message")
  final PleromaChatMessage lastMessage;

  final int unread;

  @JsonKey(name: "updated_at")
  final DateTime updatedAt;

  const PleromaChat(
    this.account,
    this.id,
    this.lastMessage,
    this.unread,
    this.updatedAt,
  );

  factory PleromaChat.fromJson(Map<String, dynamic> json) => _$PleromaChatFromJson(json);
}