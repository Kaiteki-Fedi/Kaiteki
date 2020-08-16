import 'package:kaiteki/api/model/mastodon/account.dart';
import 'package:kaiteki/api/model/pleroma/pleroma_chat_message.dart';

class PleromaChat {
  Account account;
  String id;
	PleromaChatMessage lastMessage;
  int unread;
//	dynamic updatedAt;

  PleromaChat.fromJson(Map<String, dynamic> json) {
    account = Account.fromJson(json["account"]);
    id = json["id"];

    if (json["last_message"] != null)
      lastMessage = PleromaChatMessage.fromJson(json["last_message"]);
    unread = json["unread"];
//		updatedAt = json["updated_at"];
  }
}