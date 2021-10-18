// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drive_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriveFile _$DriveFileFromJson(Map<String, dynamic> json) {
  return DriveFile(
    id: json['id'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    name: json['name'] as String,
    type: json['type'] as String,
    md5: json['md5'] as String,
    size: json['size'] as int,
    isSensitive: json['isSensitive'] as bool,
    blurhash: json['blurhash'] as String,
    properties: json['properties'] as Map<String, dynamic>,
    url: json['url'] as String,
    thumbnailUrl: json['thumbnailUrl'] as String,
    comment: json['comment'] as String,
    folderId: json['folderId'] as String,
    folder: DriveFolder.fromJson(json['folder'] as Map<String, dynamic>),
    userId: json['userId'] as String,
    user: User.fromJson(json['user'] as Map<String, dynamic>),
  );
}

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
