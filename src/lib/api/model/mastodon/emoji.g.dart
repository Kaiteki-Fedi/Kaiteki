// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MastodonEmoji _$MastodonEmojiFromJson(Map<String, dynamic> json) {
  return MastodonEmoji(
    category: json['category'] as String,
    shortcode: json['shortcode'] as String,
    staticUrl: json['static_url'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String),
    url: json['url'] as String,
    visibleInPicker: json['visible_in_picker'] as bool,
  );
}

Map<String, dynamic> _$MastodonEmojiToJson(MastodonEmoji instance) =>
    <String, dynamic>{
      'category': instance.category,
      'shortcode': instance.shortcode,
      'static_url': instance.staticUrl,
      'tags': instance.tags?.toList(),
      'url': instance.url,
      'visible_in_picker': instance.visibleInPicker,
    };
