// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drive_folder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriveFolder _$DriveFolderFromJson(Map<String, dynamic> json) => $checkedCreate(
      'DriveFolder',
      json,
      ($checkedConvert) {
        final val = DriveFolder(
          id: $checkedConvert('id', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          name: $checkedConvert('name', (v) => v as String),
          foldersCount: $checkedConvert('foldersCount', (v) => v as int?),
          filesCount: $checkedConvert('filesCount', (v) => v as int?),
          parentId: $checkedConvert('parentId', (v) => v as String?),
          parent: $checkedConvert(
              'parent',
              (v) => v == null
                  ? null
                  : DriveFolder.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$DriveFolderToJson(DriveFolder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'name': instance.name,
      'foldersCount': instance.foldersCount,
      'filesCount': instance.filesCount,
      'parentId': instance.parentId,
      'parent': instance.parent,
    };
