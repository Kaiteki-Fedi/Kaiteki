class MastodonEmoji {
  String shortcode;
  String staticUrl;
  String url;
  bool visibleInPicker;

  MastodonEmoji.fromJson(Map<String, dynamic> json) {
    shortcode = json["shortcode"];
    staticUrl = json["static_url"];
    url = json["url"];
    visibleInPicker = json["visible_in_picker"];
  }
}