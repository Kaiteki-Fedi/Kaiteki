// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Emoji _$EmojiFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Emoji',
      json,
      ($checkedConvert) {
        final val = Emoji(
          id: $checkedConvert('id', (v) => v as String?),
          aliases: $checkedConvert('aliases',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
          name: $checkedConvert('name', (v) => v as String),
          category: $checkedConvert('category', (v) => v as String?),
          host: $checkedConvert('host', (v) => v as String?),
          url: $checkedConvert('url', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$EmojiToJson(Emoji instance) => <String, dynamic>{
      'id': instance.id,
      'aliases': instance.aliases,
      'name': instance.name,
      'category': instance.category,
      'host': instance.host,
      'url': instance.url,
    };
