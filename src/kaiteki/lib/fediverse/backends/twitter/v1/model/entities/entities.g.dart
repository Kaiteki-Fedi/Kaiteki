// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Entities _$EntitiesFromJson(Map<String, dynamic> json) => Entities(
      hashtags: (json['hashtags'] as List<dynamic>?)
          ?.map((e) => Hashtag.fromJson(e as Map<String, dynamic>))
          .toList(),
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
      userMentions: (json['user_mentions'] as List<dynamic>?)
          ?.map((e) => UserMention.fromJson(e as Map<String, dynamic>))
          .toList(),
      urls: (json['urls'] as List<dynamic>?)
          ?.map((e) => Url.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EntitiesToJson(Entities instance) => <String, dynamic>{
      'hashtags': instance.hashtags,
      'media': instance.media,
      'user_mentions': instance.userMentions,
      'urls': instance.urls,
    };
