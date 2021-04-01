import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/src/mastodon/account.dart';
import 'package:fediverse_objects/src/pleroma/chat_message.dart';
part 'chat.g.dart';

@JsonSerializable(createToJson: false)
class PleromaChat {
  final MastodonAccount account;

  final String id;

  @JsonKey(name: 'last_message')
  final PleromaChatMessage lastMessage;

  final int unread;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const PleromaChat(
    this.account,
    this.id,
    this.lastMessage,
    this.unread,
    this.updatedAt,
  );

  factory PleromaChat.fromJson(Map<String, dynamic> json) =>
      _$PleromaChatFromJson(json);
}
