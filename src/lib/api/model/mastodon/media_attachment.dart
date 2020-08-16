class MediaAttachment {
  String description;
  String id;
  //dynamic pleroma;
  String previewUrl;
  String remoteUrl;
  String textUrl;
  String type;
  String url;

  MediaAttachment.fromJson(Map<String, dynamic> json) {
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