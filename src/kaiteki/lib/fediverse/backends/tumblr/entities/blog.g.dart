// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Blog _$BlogFromJson(Map<String, dynamic> json) => Blog(
      followers: json['followers'] as int?,
      name: json['name'] as String,
      primary: json['primary'] as bool?,
      title: json['title'] as String,
      type: $enumDecodeNullable(_$BlogTypeEnumMap, json['type']),
      url: Uri.parse(json['url'] as String),
      ask: json['ask'] as bool?,
      askAnon: json['ask_anon'] as bool?,
      avatar: (json['avatar'] as List<dynamic>?)
          ?.map((e) => Avatar.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String?,
      followed: json['followed'] as bool?,
      isBlockedFromPrimary: json['is_blocked_from_primary'] as bool?,
      likes: json['likes'] as int?,
      posts: json['posts'] as int?,
      theme: json['theme'] == null
          ? null
          : BlogTheme.fromJson(json['theme'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BlogToJson(Blog instance) => <String, dynamic>{
      'theme': instance.theme,
      'type': _$BlogTypeEnumMap[instance.type],
      'ask': instance.ask,
      'ask_anon': instance.askAnon,
      'followed': instance.followed,
      'is_blocked_from_primary': instance.isBlockedFromPrimary,
      'primary': instance.primary,
      'followers': instance.followers,
      'likes': instance.likes,
      'posts': instance.posts,
      'avatar': instance.avatar,
      'name': instance.name,
      'title': instance.title,
      'description': instance.description,
      'url': instance.url.toString(),
    };

const _$BlogTypeEnumMap = {
  BlogType.public: 'public',
  BlogType.private: 'private',
};
