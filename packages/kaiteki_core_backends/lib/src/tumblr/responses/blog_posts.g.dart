// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_posts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogPostsResponse _$BlogPostsResponseFromJson(Map<String, dynamic> json) =>
    BlogPostsResponse(
      posts: (json['posts'] as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList(),
      blog: Blog.fromJson(json['blog'] as Map<String, dynamic>),
      totalPosts: json['total_posts'] as int,
    );

Map<String, dynamic> _$BlogPostsResponseToJson(BlogPostsResponse instance) =>
    <String, dynamic>{
      'posts': instance.posts,
      'blog': instance.blog,
      'total_posts': instance.totalPosts,
    };
