// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji_pack_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmojiPackMetadata _$EmojiPackMetadataFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'EmojiPackMetadata',
      json,
      ($checkedConvert) {
        final val = EmojiPackMetadata(
          canDownload: $checkedConvert('can-download', (v) => v as bool),
          description: $checkedConvert('description', (v) => v as String),
          downloadSha256:
              $checkedConvert('download-sha256', (v) => v as String),
          fallbackSource: $checkedConvert('fallback-src', (v) => v as String),
          fallbackSourceSha256:
              $checkedConvert('fallback-src-sha256', (v) => v as String),
          homepage: $checkedConvert('homepage', (v) => v as String),
          license: $checkedConvert('license', (v) => v as String),
          shareFiles: $checkedConvert('share-files', (v) => v as bool),
        );
        return val;
      },
      fieldKeyMap: const {
        'canDownload': 'can-download',
        'downloadSha256': 'download-sha256',
        'fallbackSource': 'fallback-src',
        'fallbackSourceSha256': 'fallback-src-sha256',
        'shareFiles': 'share-files'
      },
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
