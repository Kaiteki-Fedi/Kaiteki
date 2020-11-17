// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji_packs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaEmojiPacksResponse _$PleromaEmojiPacksResponseFromJson(
    Map<String, dynamic> json) {
  return PleromaEmojiPacksResponse(
    count: json['count'] as int,
    packs: (json['packs'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : PleromaEmojiPack.fromJson(e as Map<String, dynamic>)),
    ),
  );
}
