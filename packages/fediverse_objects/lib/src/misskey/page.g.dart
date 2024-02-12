// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Page _$PageFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Page',
      json,
      ($checkedConvert) {
        final val = Page(
          id: $checkedConvert('id', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          updatedAt:
              $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
          title: $checkedConvert('title', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          summary: $checkedConvert('summary', (v) => v as String?),
          content: $checkedConvert('content', (v) => v as List<dynamic>),
          variables: $checkedConvert('variables', (v) => v as List<dynamic>),
          userId: $checkedConvert('userId', (v) => v as String),
          user: $checkedConvert(
              'user', (v) => User.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$PageToJson(Page instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'title': instance.title,
      'name': instance.name,
      'summary': instance.summary,
      'content': instance.content,
      'variables': instance.variables,
      'userId': instance.userId,
      'user': instance.user,
    };
