import 'package:json_annotation/json_annotation.dart';

part 'emoji_pack_metadata.g.dart';

@JsonSerializable()
class EmojiPackMetadata {
  @JsonKey(name: 'can-download')
  final bool canDownload;

  final String description;

  @JsonKey(name: 'download-sha256')
  final String downloadSha256;

  @JsonKey(name: 'fallback-src')
  final String fallbackSource;

  @JsonKey(name: 'fallback-src-sha256')
  final String fallbackSourceSha256;

  @JsonKey(name: 'homepage')
  final String homepage;

  @JsonKey(name: 'license')
  final String license;

  @JsonKey(name: 'share-files')
  final bool shareFiles;

  const EmojiPackMetadata({
    required this.canDownload,
    required this.description,
    required this.downloadSha256,
    required this.fallbackSource,
    required this.fallbackSourceSha256,
    required this.homepage,
    required this.license,
    required this.shareFiles,
  });

  factory EmojiPackMetadata.fromJson(Map<String, dynamic> json) =>
      _$EmojiPackMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$EmojiPackMetadataToJson(this);
}
