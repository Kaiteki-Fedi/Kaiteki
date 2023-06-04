import 'package:json_annotation/json_annotation.dart';
import 'package:recase/recase.dart';
import 'package:kaiteki_core/utils.dart';

part 'media.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class Media {
  final String mediaKey;
  final MediaType type;
  final String? url;
  final int? height;
  final int? durationMs;
  final String? previewImageUrl;
  final int? width;
  final String? altText;

  const Media({
    required this.mediaKey,
    required this.type,
    this.url,
    this.height,
    this.durationMs,
    this.previewImageUrl,
    this.width,
    this.altText,
  });

  factory Media.fromJson(JsonMap json) => _$MediaFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum MediaType { video, animatedGif, photo }

typedef MediaFields = Set<MediaField>;

enum MediaField {
  url,
  durationMs,
  height,
  nonPublicMetrics,
  organicMetrics,
  previewImageUrl,
  promotedMetrics,
  publicMetrics,
  width,
  altText,
  variants;

  @override
  String toString() => name.snakeCase;
}
