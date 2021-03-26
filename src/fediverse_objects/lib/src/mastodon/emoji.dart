import 'package:json_annotation/json_annotation.dart';

part 'emoji.g.dart';

/// Represents a custom emoji.
@JsonSerializable()
class MastodonEmoji {
  /// Used for sorting custom emoji in the picker.
  final String? category;

  /// The name of the custom emoji.
  final String shortcode;

  /// A link to a static copy of the custom emoji.
  @JsonKey(name: 'static_url')
  final String staticUrl;

  /// The tags of the custom emoji. (Pleroma-only)
  final Iterable<String>? tags;

  /// A link to the custom emoji.
  final String url;

  /// Whether this Emoji should be visible in the picker or unlisted.
  @JsonKey(name: 'visible_in_picker')
  final bool visibleInPicker;

  const MastodonEmoji({
    required this.shortcode,
    required this.url,
    required this.staticUrl,
    required this.visibleInPicker,
    this.category,
    this.tags,
  });

  factory MastodonEmoji.fromJson(Map<String, dynamic> json) =>
      _$MastodonEmojiFromJson(json);

  Map<String, dynamic> toJson() => _$MastodonEmojiToJson(this);
}
