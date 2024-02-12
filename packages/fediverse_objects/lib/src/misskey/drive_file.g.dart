// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drive_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriveFile _$DriveFileFromJson(Map<String, dynamic> json) => $checkedCreate(
      'DriveFile',
      json,
      ($checkedConvert) {
        final val = DriveFile(
          id: $checkedConvert('id', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          name: $checkedConvert('name', (v) => v as String),
          type: $checkedConvert('type', (v) => v as String),
          md5: $checkedConvert('md5', (v) => v as String),
          size: $checkedConvert('size', (v) => v as int),
          isSensitive: $checkedConvert('isSensitive', (v) => v as bool),
          blurhash: $checkedConvert('blurhash', (v) => v as String?),
          properties:
              $checkedConvert('properties', (v) => v as Map<String, dynamic>),
          url: $checkedConvert('url', (v) => v as String?),
          thumbnailUrl: $checkedConvert('thumbnailUrl', (v) => v as String?),
          comment: $checkedConvert('comment', (v) => v as String?),
          folderId: $checkedConvert('folderId', (v) => v as String?),
          folder: $checkedConvert(
              'folder',
              (v) => v == null
                  ? null
                  : DriveFolder.fromJson(v as Map<String, dynamic>)),
          userId: $checkedConvert('userId', (v) => v as String?),
          user: $checkedConvert(
              'user',
              (v) =>
                  v == null ? null : User.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$DriveFileToJson(DriveFile instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'name': instance.name,
      'type': instance.type,
      'md5': instance.md5,
      'size': instance.size,
      'isSensitive': instance.isSensitive,
      'blurhash': instance.blurhash,
      'properties': instance.properties,
      'url': instance.url,
      'thumbnailUrl': instance.thumbnailUrl,
      'comment': instance.comment,
      'folderId': instance.folderId,
      'folder': instance.folder,
      'userId': instance.userId,
      'user': instance.user,
    };
