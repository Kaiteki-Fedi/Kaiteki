// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji_pack_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmojiPackMetadata _$EmojiPackMetadataFromJson(Map<String, dynamic> json) =>
    EmojiPackMetadata(
      canDownload: json['can-download'] as bool,
      description: json['description'] as String,
      downloadSha256: json['download-sha256'] as String,
      fallbackSource: json['fallback-src'] as String,
      fallbackSourceSha256: json['fallback-src-sha256'] as String,
      homepage: json['homepage'] as String,
      license: json['license'] as String,
      shareFiles: json['share-files'] as bool,
    );

Map<String, dynamic> _$EmojiPackMetadataToJson(EmojiPackMetadata instance) =>
    <String, dynamic>{
      'can-download': instance.canDownload,
      'description': instance.description,
      'download-sha256': instance.downloadSha256,
      'fallback-src': instance.fallbackSource,
      'fallback-src-sha256': instance.fallbackSourceSha256,
      'homepage': instance.homepage,
      'license': instance.license,
      'share-files': instance.shareFiles,
    };
