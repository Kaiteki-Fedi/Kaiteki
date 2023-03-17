// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Blog _$BlogFromJson(Map<String, dynamic> json) => Blog(
      name: json['name'] as String,
      url: Uri.parse(json['url'] as String),
      title: json['title'] as String,
      primary: json['primary'] as bool,
      followers: json['followers'] as int,
      tweet: json['tweet'] as String,
      type: $enumDecode(_$BlogTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$BlogToJson(Blog instance) => <String, dynamic>{
      'name': instance.name,
      'url': instance.url.toString(),
      'title': instance.title,
      'primary': instance.primary,
      'followers': instance.followers,
      'tweet': instance.tweet,
      'type': _$BlogTypeEnumMap[instance.type]!,
    };

const _$BlogTypeEnumMap = {
  BlogType.public: 'public',
  BlogType.private: 'private',
};
