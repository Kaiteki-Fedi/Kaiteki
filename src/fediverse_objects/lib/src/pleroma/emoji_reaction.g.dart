// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmojiReaction _$EmojiReactionFromJson(Map<String, dynamic> json) =>
    EmojiReaction(
      accounts: (json['accounts'] as List<dynamic>?)
          ?.map((e) => Account.fromJson(e as Map<String, dynamic>)),
      count: json['count'] as int,
      me: json['me'] as bool,
      name: json['name'] as String,
    );

Map<String, dynamic> _$EmojiReactionToJson(EmojiReaction instance) =>
    <String, dynamic>{
      'accounts': instance.accounts?.toList(),
      'count': instance.count,
      'me': instance.me,
      'name': instance.name,
    };
