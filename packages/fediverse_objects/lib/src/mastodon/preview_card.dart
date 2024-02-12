import 'package:json_annotation/json_annotation.dart';

import '../pleroma/card.dart';
import 'trends_history.dart';

part 'preview_card.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PreviewCard {
  /// Location of linked resource.
  final Uri url;

  /// Title of linked resource.
  final String title;

  /// Description of preview.
  final String description;

  /// Description of preview.
  final PreviewCardType type;

  /// The author of the original resource.
  final String? authorName;

  /// A link to the author of the original resource.
  final Uri? authorUrl;

  /// The provider of the original resource.
  final String providerName;

  /// A link to the provider of the original resource.
  final Uri? providerUrl;

  /// HTML to be used for generating the preview card.
  final String? html;

  /// Width of preview, in pixels.
  final int? width;

  /// Height of preview, in pixels.
  final int? height;

  /// Preview thumbnail.
  final Uri? image;

  /// Used for photo embeds, instead of custom `html`.
  final Uri? embedUrl;

  /// A hash computed by [the BlurHash algorithm](https://github.com/woltapp/blurhash),
  /// for generating colorful preview thumbnails when media has not been downloaded yet.
  final String? blurhash;

  /// Pleroma extensions
  final PleromaCard? pleroma;

  const PreviewCard({
    required this.url,
    required this.title,
    required this.description,
    required this.type,
    required this.authorName,
    this.authorUrl,
    required this.providerName,
    this.providerUrl,
    required this.html,
    required this.width,
    required this.height,
    this.image,
    this.embedUrl,
    this.blurhash,
    this.pleroma,
  });

  factory PreviewCard.fromJson(Map<String, dynamic> json) =>
      _$PreviewCardFromJson(json);

  Map<String, dynamic> toJson() => _$PreviewCardToJson(this);
}

enum PreviewCardType {
  /// Link OEmbed,
  link,

  /// Photo OEmbed,
  photo,

  /// Video OEmbed,
  video,

  /// iframe OEmbed. Not currently accepted, so won’t show up in practice.
  rich,
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TrendsLink extends PreviewCard {
  final List<TrendsHistory> history;

  const TrendsLink({
    required super.url,
    required super.title,
    required super.description,
    required super.type,
    required super.authorName,
    required super.providerName,
    required super.html,
    required super.width,
    required super.height,
    required this.history,
  });

  factory TrendsLink.fromJson(Map<String, dynamic> json) =>
      _$TrendsLinkFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TrendsLinkToJson(this);
}
