import 'package:json_annotation/json_annotation.dart';

part 'emoji.g.dart';

@JsonSerializable(createToJson: false)
class MastodonEmoji {
  final String category;

  final String shortcode;

  @JsonKey(name: "static_url")
  final String staticUrl;

  // This is part of Pleroma.
  final Iterable<String> tags;

  final String url;

  @JsonKey(name: "visible_in_picker")
  final bool visibleInPicker;

  const MastodonEmoji({
    this.category,
    this.shortcode,
    this.staticUrl,
    this.tags,
    this.url,
    this.visibleInPicker,
  });

  factory MastodonEmoji.fromJson(Map<String, dynamic> json) =>
      _$MastodonEmojiFromJson(json);
}
