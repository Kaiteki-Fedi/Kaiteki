// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmojiGroup _$EmojiGroupFromJson(Map<String, dynamic> json) => EmojiGroup(
      json['group'] as String,
      (json['emoji'] as List<dynamic>)
          .map((e) => Emoji.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
