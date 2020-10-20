// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaEmojiReaction _$PleromaEmojiReactionFromJson(Map<String, dynamic> json) {
  return PleromaEmojiReaction(
    accounts: (json['accounts'] as List)?.map((e) =>
        e == null ? null : MastodonAccount.fromJson(e as Map<String, dynamic>)),
    count: json['count'] as int,
    me: json['me'] as bool,
    name: json['name'] as String,
  );
}
