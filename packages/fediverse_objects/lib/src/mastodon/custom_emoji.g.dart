// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_emoji.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomEmoji _$CustomEmojiFromJson(Map<String, dynamic> json) => $checkedCreate(
      'CustomEmoji',
      json,
      ($checkedConvert) {
        final val = CustomEmoji(
          shortcode: $checkedConvert('shortcode', (v) => v as String),
          url: $checkedConvert('url', (v) => v as String),
          staticUrl: $checkedConvert('static_url', (v) => v as String),
          visibleInPicker:
              $checkedConvert('visible_in_picker', (v) => v as bool),
          category: $checkedConvert('category', (v) => v as String?),
          tags: $checkedConvert('tags',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'staticUrl': 'static_url',
        'visibleInPicker': 'visible_in_picker'
      },
    );

Map<String, dynamic> _$CustomEmojiToJson(CustomEmoji instance) =>
    <String, dynamic>{
      'category': instance.category,
      'shortcode': instance.shortcode,
      'static_url': instance.staticUrl,
      'tags': instance.tags,
      'url': instance.url,
      'visible_in_picker': instance.visibleInPicker,
    };
