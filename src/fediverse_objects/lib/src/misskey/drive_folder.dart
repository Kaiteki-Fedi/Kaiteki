import 'package:json_annotation/json_annotation.dart';

part 'drive_folder.g.dart';

@JsonSerializable()
class DriveFolder {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'foldersCount')
  final int? foldersCount;

  @JsonKey(name: 'filesCount')
  final int? filesCount;

  @JsonKey(name: 'parentId')
  final String? parentId;

  @JsonKey(name: 'parent')
  final DriveFolder? parent;

  const DriveFolder({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.foldersCount,
    required this.filesCount,
    this.parentId,
    this.parent,
  });

  factory DriveFolder.fromJson(Map<String, dynamic> json) =>
      _$DriveFolderFromJson(json);

  Map<String, dynamic> toJson() => _$DriveFolderToJson(this);
}
