import 'package:kaiteki/api/model/mastodon/account.dart';
import 'package:kaiteki/api/model/mastodon/status.dart';
import 'package:kaiteki/api/model/pleroma/pleroma_notification.dart';

class Notification {
  Account account;
  //dynamic createdAt;
  String emoji;
  String id;
  PleromaNotification pleroma;
  Status status;
  String type;

  Notification.fromJson(Map<String, dynamic> json) {
    account = Account.fromJson(json["account"]);
    //createdAt = json["createdAt"];
    emoji = json["emoji"];
    id = json["id"];

    if (json["pleroma"] != null)
      pleroma = PleromaNotification.fromJson(json["pleroma"]);

    if (json["status"] != null)
      status = Status.fromJson(json["status"]);

    type = json["type"];
  }
}