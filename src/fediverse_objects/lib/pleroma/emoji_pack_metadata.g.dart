// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji_pack_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaEmojiPackMetadata _$PleromaEmojiPackMetadataFromJson(
    Map<String, dynamic> json) {
  return PleromaEmojiPackMetadata(
    canDownload: json['can-download'] as bool,
    description: json['description'] as String,
    downloadSha256: json['download-sha256'] as String,
    fallbackSource: json['fallback-src'] as String,
    fallbackSourceSha256: json['fallback-src-sha256'] as String,
    homepage: json['homepage'] as String,
    license: json['license'] as String,
    shareFiles: json['share-files'] as bool,
  );
}
