import 'package:kaiteki/api/model/mastodon/emoji.dart';
import 'package:kaiteki/api/model/mastodon/media_attachment.dart';

class PleromaChatMessage {
  String accountId;
  String chatId;
  MastodonMediaAttachment attachment;
  dynamic card;
  String content;
//	dynamic createdAt;
  Iterable<MastodonEmoji> emojis;
  String id;
  bool unread;

  PleromaChatMessage.fromJson(Map<String, dynamic> json) {
    accountId = json["account_id"];
    chatId = json["chat_id"];
    content = json["content"];
//		createdAt = json["created_at"];

    if (json["emojis"] != null)
      emojis = json["emojis"].map<MastodonEmoji>((j) => MastodonEmoji.fromJson(j));

    if (json["attachment"] != null)
      attachment = MastodonMediaAttachment.fromJson(json["attachment"]);

    id = json["id"];
    unread = json["unread"];
  }
}
