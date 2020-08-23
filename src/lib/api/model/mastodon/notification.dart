import 'package:kaiteki/api/model/mastodon/account.dart';
import 'package:kaiteki/api/model/mastodon/status.dart';
import 'package:kaiteki/api/model/pleroma/notification.dart';

class MastodonNotification {
  MastodonAccount account;
  //dynamic createdAt;
  String emoji;
  String id;
  PleromaNotification pleroma;
  MastodonStatus status;
  String type;

  MastodonNotification.fromJson(Map<String, dynamic> json) {
    account = MastodonAccount.fromJson(json["account"]);
    //createdAt = json["createdAt"];
    emoji = json["emoji"];
    id = json["id"];

    if (json["pleroma"] != null)
      pleroma = PleromaNotification.fromJson(json["pleroma"]);

    if (json["status"] != null)
      status = MastodonStatus.fromJson(json["status"]);

    type = json["type"];
  }
}