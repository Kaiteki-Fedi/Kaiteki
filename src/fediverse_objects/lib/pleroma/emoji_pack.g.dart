// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji_pack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaEmojiPack _$PleromaEmojiPackFromJson(Map<String, dynamic> json) {
  return PleromaEmojiPack(
    files: (json['files'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    pack: json['pack'] == null
        ? null
        : PleromaEmojiPackMetadata.fromJson(
            json['pack'] as Map<String, dynamic>),
    fileCount: json['files_count'] as int,
  );
}
