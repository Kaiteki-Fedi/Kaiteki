// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji_pack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaEmojiPack _$PleromaEmojiPackFromJson(Map<String, dynamic> json) {
  return PleromaEmojiPack(
    files: Map<String, String>.from(json['files'] as Map),
    pack:
        PleromaEmojiPackMetadata.fromJson(json['pack'] as Map<String, dynamic>),
    fileCount: json['files_count'] as int?,
  );
}
