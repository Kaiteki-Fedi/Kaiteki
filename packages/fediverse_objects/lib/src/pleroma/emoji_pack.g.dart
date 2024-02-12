// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji_pack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmojiPack _$EmojiPackFromJson(Map<String, dynamic> json) => $checkedCreate(
      'EmojiPack',
      json,
      ($checkedConvert) {
        final val = EmojiPack(
          files: $checkedConvert(
              'files', (v) => Map<String, String>.from(v as Map)),
          pack: $checkedConvert('pack',
              (v) => EmojiPackMetadata.fromJson(v as Map<String, dynamic>)),
          fileCount: $checkedConvert('files_count', (v) => v as int?),
        );
        return val;
      },
      fieldKeyMap: const {'fileCount': 'files_count'},
    );
