// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drive_folder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyDriveFolder _$MisskeyDriveFolderFromJson(Map<String, dynamic> json) {
  return MisskeyDriveFolder(
    id: json['id'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    name: json['name'] as String,
    foldersCount: json['foldersCount'] as int,
    filesCount: json['filesCount'] as int,
    parentId: json['parentId'] as String,
    parent: json['parent'] == null
        ? null
        : MisskeyDriveFolder.fromJson(json['parent'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MisskeyDriveFolderToJson(MisskeyDriveFolder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'name': instance.name,
      'foldersCount': instance.foldersCount,
      'filesCount': instance.filesCount,
      'parentId': instance.parentId,
      'parent': instance.parent,
    };
