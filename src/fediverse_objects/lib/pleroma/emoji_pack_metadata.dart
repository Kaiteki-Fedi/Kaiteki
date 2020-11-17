import 'package:json_annotation/json_annotation.dart';

part 'emoji_pack_metadata.g.dart';

@JsonSerializable(createToJson: false)
class PleromaEmojiPackMetadata {
  @JsonKey(name: "can-download")
  final bool canDownload;

  final String description;

  @JsonKey(name: "download-sha256")
  final String downloadSha256;

  @JsonKey(name: "fallback-src")
  final String fallbackSource;

  @JsonKey(name: "fallback-src-sha256")
  final String fallbackSourceSha256;

  @JsonKey(name: "homepage")
  final String homepage;

  @JsonKey(name: "license")
  final String license;

  @JsonKey(name: "share-files")
  final bool shareFiles;

  const PleromaEmojiPackMetadata({
    this.canDownload,
    this.description,
    this.downloadSha256,
    this.fallbackSource,
    this.fallbackSourceSha256,
    this.homepage,
    this.license,
    this.shareFiles,
  });

  factory PleromaEmojiPackMetadata.fromJson(Map<String, dynamic> json) =>
      _$PleromaEmojiPackMetadataFromJson(json);
}
