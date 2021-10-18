import 'package:fediverse_objects/mastodon.dart' as mastodon;
import 'package:fediverse_objects/src/pleroma/chat_message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable(createToJson: false)
class Chat {
  final mastodon.Account account;

  final String id;

  @JsonKey(name: 'last_message')
  final ChatMessage lastMessage;

  final int unread;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const Chat(
    this.account,
    this.id,
    this.lastMessage,
    this.unread,
    this.updatedAt,
  );

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}
