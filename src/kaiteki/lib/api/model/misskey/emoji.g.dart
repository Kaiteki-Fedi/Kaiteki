// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyEmoji _$MisskeyEmojiFromJson(Map<String, dynamic> json) {
  return MisskeyEmoji(
    id: json['id'] as String,
    aliases: (json['aliases'] as List)?.map((e) => e as String),
    name: json['name'] as String,
    category: json['category'] as String,
    host: json['host'] as String,
    url: json['url'] as String,
  );
}
