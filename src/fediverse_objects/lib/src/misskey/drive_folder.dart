import 'package:json_annotation/json_annotation.dart';
part 'drive_folder.g.dart';

@JsonSerializable()
class MisskeyDriveFolder {
  /// The unique identifier for this Drive folder.
  @JsonKey(name: 'id')
  final String id;
  
  /// The date that the Drive folder was created.
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  
  /// The folder name.
  @JsonKey(name: 'name')
  final String name;
  
  /// The count of child folders.
  @JsonKey(name: 'foldersCount')
  final int foldersCount;
  
  /// The count of child files.
  @JsonKey(name: 'filesCount')
  final int filesCount;
  
  /// The parent folder ID of this folder.
  @JsonKey(name: 'parentId')
  final String parentId;
  
  @JsonKey(name: 'parent')
  final MisskeyDriveFolder parent;
  
  const MisskeyDriveFolder({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.foldersCount,
    required this.filesCount,
    required this.parentId,
    required this.parent,
  });

  factory MisskeyDriveFolder.fromJson(Map<String, dynamic> json) => _$MisskeyDriveFolderFromJson(json);
  Map<String, dynamic> toJson() => _$MisskeyDriveFolderToJson(this);
}
