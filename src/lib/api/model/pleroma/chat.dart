import 'package:kaiteki/api/model/mastodon/account.dart';
import 'package:kaiteki/api/model/pleroma/chat_message.dart';

class PleromaChat {
  MastodonAccount account;
  String id;
	PleromaChatMessage lastMessage;
  int unread;
//	dynamic updatedAt;

  PleromaChat.fromJson(Map<String, dynamic> json) {
    account = MastodonAccount.fromJson(json["account"]);
    id = json["id"];

    if (json["last_message"] != null)
      lastMessage = PleromaChatMessage.fromJson(json["last_message"]);
    unread = json["unread"];
//		updatedAt = json["updated_at"];
  }
}