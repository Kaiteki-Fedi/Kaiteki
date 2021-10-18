// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Emoji _$EmojiFromJson(Map<String, dynamic> json) {
  return Emoji(
    shortcode: json['shortcode'] as String,
    url: json['url'] as String,
    staticUrl: json['static_url'] as String,
    visibleInPicker: json['visible_in_picker'] as bool,
    category: json['category'] as String?,
    tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String),
  );
}

Map<String, dynamic> _$EmojiToJson(Emoji instance) => <String, dynamic>{
      'category': instance.category,
      'shortcode': instance.shortcode,
      'static_url': instance.staticUrl,
      'tags': instance.tags?.toList(),
      'url': instance.url,
      'visible_in_picker': instance.visibleInPicker,
    };
