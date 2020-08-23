class MastodonMediaAttachment {
  String description;
  String id;
  //dynamic pleroma;
  String previewUrl;
  String remoteUrl;
  String textUrl;
  String type;
  String url;

  MastodonMediaAttachment.fromJson(Map<String, dynamic> json) {
    description = json["description"];
    id = json["id"];
    //pleroma = json["pleroma"];
    previewUrl = json["previewUrl"];
    remoteUrl = json["remoteUrl"];
    textUrl = json["textUrl"];
    type = json["type"];
    url = json["url"];
  }
}