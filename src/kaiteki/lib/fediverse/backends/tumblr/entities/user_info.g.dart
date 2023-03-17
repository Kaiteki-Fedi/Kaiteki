// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      following: json['following'] as int,
      defaultPostFormat: json['default_post_format'] as String,
      likes: json['likes'] as int,
      blogs: (json['blogs'] as List<dynamic>)
          .map((e) => Blog.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'following': instance.following,
      'default_post_format': instance.defaultPostFormat,
      'blogs': instance.blogs,
      'likes': instance.likes,
      'name': instance.name,
    };
