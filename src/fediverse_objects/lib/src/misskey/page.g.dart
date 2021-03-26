// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyPage _$MisskeyPageFromJson(Map<String, dynamic> json) {
  return MisskeyPage(
    id: json['id'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    title: json['title'] as String,
    name: json['name'] as String,
    summary: json['summary'] as String,
    content: json['content'] as List<dynamic>,
    variables: json['variables'] as List<dynamic>,
    userId: json['userId'] as String,
    user: MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MisskeyPageToJson(MisskeyPage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'title': instance.title,
      'name': instance.name,
      'summary': instance.summary,
      'content': instance.content.toList(),
      'variables': instance.variables.toList(),
      'userId': instance.userId,
      'user': instance.user,
    };
