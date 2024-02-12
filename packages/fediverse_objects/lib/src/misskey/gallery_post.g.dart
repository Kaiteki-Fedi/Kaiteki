// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GalleryPost _$GalleryPostFromJson(Map<String, dynamic> json) => $checkedCreate(
      'GalleryPost',
      json,
      ($checkedConvert) {
        final val = GalleryPost(
          id: $checkedConvert('id', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          updatedAt:
              $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
          title: $checkedConvert('title', (v) => v as String),
          description: $checkedConvert('description', (v) => v as String?),
          userId: $checkedConvert('userId', (v) => v as String),
          user: $checkedConvert(
              'user', (v) => User.fromJson(v as Map<String, dynamic>)),
          fileIds: $checkedConvert('fileIds',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
          files: $checkedConvert(
              'files',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => DriveFile.fromJson(e as Map<String, dynamic>))
                  .toList()),
          tags: $checkedConvert('tags',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
          isSensitive: $checkedConvert('isSensitive', (v) => v as bool),
        );
        return val;
      },
    );

Map<String, dynamic> _$GalleryPostToJson(GalleryPost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'title': instance.title,
      'description': instance.description,
      'userId': instance.userId,
      'user': instance.user,
      'fileIds': instance.fileIds,
      'files': instance.files,
      'tags': instance.tags,
      'isSensitive': instance.isSensitive,
    };
