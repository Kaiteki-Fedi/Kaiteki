import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/fediverse/backends/twitter/v1/model/entities/entity.dart';

part 'media.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Media extends Entity {
  /// URL of the media to display to clients.
  final String displayUrl;

  /// An expanded version of display_url. Links to the media display page.
  final String expandedUrl;

  /// ID of the media expressed as a 64-bit integer.
  final int id;

  /// ID of the media expressed as a string.
  final String idStr;

  /// An http:// URL pointing directly to the uploaded media file.
  final String mediaUrl;

  /// An https:// URL pointing directly to the uploaded media file,
  /// for embedding on https pages.
  final String mediaUrlHttps;

  /// Type of uploaded media.
  ///
  /// Possible types include `photo`, `video`, and `animated_gif`.
  final String type;

  const Media({
    required this.displayUrl,
    required this.expandedUrl,
    required this.id,
    required this.idStr,
    required this.mediaUrl,
    required this.mediaUrlHttps,
    required this.type,
    required List<int> indices,
  }) : super(indices);

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

  Map<String, dynamic> toJson() => _$MediaToJson(this);
}
