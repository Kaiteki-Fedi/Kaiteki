// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyPage _$MisskeyPageFromJson(Map<String, dynamic> json) {
  return MisskeyPage(
    id: json['id'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String),
    userId: json['userId'] as String,
    user: json['user'] == null
        ? null
        : MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
    content: (json['content'] as List)?.map((e) => e as Map<String, dynamic>),
    variables: (json['variables'] as List)?.map((e) => e == null
        ? null
        : MisskeyPageVariable.fromJson(e as Map<String, dynamic>)),
    title: json['title'] as String,
    name: json['name'] as String,
    summary: json['summary'],
    hideTitleWhenPinned: json['hideTitleWhenPinned'] as bool,
    alignCenter: json['alignCenter'] as bool,
    font: json['font'] as String,
    script: json['script'] as String,
    eyeCatchingImageId: json['eyeCatchingImageId'] as String,
    eyeCatchingImage: json['eyeCatchingImage'],
    likedCount: json['likedCount'] as int,
    isLiked: json['isLiked'] as bool,
  );
}
