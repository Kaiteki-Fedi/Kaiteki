import 'package:json_annotation/json_annotation.dart';
part 'drive_folder.g.dart';

@JsonSerializable()
class DriveFolder {
  final String id;

  final DateTime createdAt;

  final String name;

  final int? foldersCount;

  final int? filesCount;

  final String? parentId;

  final DriveFolder? parent;

  const DriveFolder({
    required this.id,
    required this.createdAt,
    required this.name,
    this.foldersCount,
    this.filesCount,
    this.parentId,
    this.parent,
  });

  factory DriveFolder.fromJson(Map<String, dynamic> json) =>
      _$DriveFolderFromJson(json);
  Map<String, dynamic> toJson() => _$DriveFolderToJson(this);
}
