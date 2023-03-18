// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogInfoResponse _$BlogInfoResponseFromJson(Map<String, dynamic> json) =>
    BlogInfoResponse(
      blog: Blog.fromJson(json['blog'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BlogInfoResponseToJson(BlogInfoResponse instance) =>
    <String, dynamic>{
      'blog': instance.blog,
    };
