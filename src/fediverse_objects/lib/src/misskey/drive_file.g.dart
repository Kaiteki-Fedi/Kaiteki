// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drive_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyDriveFile _$MisskeyDriveFileFromJson(Map<String, dynamic> json) {
  return MisskeyDriveFile(
    id: json['id'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
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
    folder: json['folder'] == null
        ? null
        : MisskeyDriveFolder.fromJson(json['folder'] as Map<String, dynamic>),
    userId: json['userId'] as String,
    user: json['user'] == null
        ? null
        : MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MisskeyDriveFileToJson(MisskeyDriveFile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
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
