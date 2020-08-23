class MisskeyPageComponent {
  String id;
  String text;
  String type;

  Map<String, dynamic> raw;

  MisskeyPageComponent.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    text = json["text"];
    type = json["type"];

    raw = json;
  }
}