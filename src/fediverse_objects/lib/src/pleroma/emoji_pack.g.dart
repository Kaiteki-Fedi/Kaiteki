// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji_pack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmojiPack _$EmojiPackFromJson(Map<String, dynamic> json) {
  return EmojiPack(
    files: Map<String, String>.from(json['files'] as Map),
    pack: EmojiPackMetadata.fromJson(json['pack'] as Map<String, dynamic>),
    fileCount: json['files_count'] as int?,
  );
}
