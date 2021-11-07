// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Emoji _$EmojiFromJson(Map<String, dynamic> json) => Emoji(
      id: json['id'] as String?,
      aliases: (json['aliases'] as List<dynamic>?)?.map((e) => e as String),
      name: json['name'] as String,
      category: json['category'] as String?,
      host: json['host'] as String?,
      url: json['url'] as String,
    );

Map<String, dynamic> _$EmojiToJson(Emoji instance) => <String, dynamic>{
      'id': instance.id,
      'aliases': instance.aliases?.toList(),
      'name': instance.name,
      'category': instance.category,
      'host': instance.host,
      'url': instance.url,
    };
