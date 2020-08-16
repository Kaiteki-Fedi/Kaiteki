class Emoji {
  String shortcode;
  String staticUrl;
  String url;
  bool visibleInPicker;

  Emoji.fromJson(Map<String, dynamic> json) {
    shortcode = json["shortcode"];
    staticUrl = json["static_url"];
    url = json["url"];
    visibleInPicker = json["visible_in_picker"];
  }
}