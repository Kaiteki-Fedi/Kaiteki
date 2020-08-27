import 'package:kaiteki/api/model/pleroma/card.dart';

class MastodonCard {
  String description;
  String image;
  PleromaCard pleroma;
  String providerName;
  String providerUrl;
  String title;
  String type;
  String url;

  MastodonCard.fromJson(Map<String, dynamic> json) {
    description = json["description"];
    image = json["image"];

    if (json["pleroma"] != null)
      pleroma = PleromaCard.fromJson(json["pleroma"]);

    providerName = json["providerName"];
    providerUrl = json["providerUrl"];
    title = json["title"];
    type = json["type"];
    url = json["url"];
  }
}