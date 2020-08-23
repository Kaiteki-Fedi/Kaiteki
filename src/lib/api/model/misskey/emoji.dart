class MisskeyEmoji {
  String name;
  String host;
  String url;
  List<String> aliases;

  MisskeyEmoji.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    host = json["host"];
    url = json["url"];
    aliases = json["aliases"].cast<String>();
  }
}