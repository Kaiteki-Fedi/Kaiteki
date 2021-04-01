import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/src/misskey/drive_folder.dart';
import 'package:fediverse_objects/src/misskey/user.dart';
part 'drive_file.g.dart';

@JsonSerializable()
class MisskeyDriveFile {
  /// The unique identifier for this Drive file.
  @JsonKey(name: 'id')
  final String id;
  
  /// The date that the Drive file was created on Misskey.
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  
  /// The file name with extension.
  @JsonKey(name: 'name')
  final String name;
  
  /// The MIME type of this Drive file.
  @JsonKey(name: 'type')
  final String type;
  
  /// The MD5 hash of this Drive file.
  @JsonKey(name: 'md5')
  final String md5;
  
  /// The size of this Drive file. (bytes)
  @JsonKey(name: 'size')
  final int size;
  
  /// Whether this Drive file is sensitive.
  @JsonKey(name: 'isSensitive')
  final bool isSensitive;
  
  @JsonKey(name: 'blurhash')
  final String blurhash;
  
  @JsonKey(name: 'properties')
  final Map<String, dynamic> properties;
  
  /// The URL of this Drive file.
  @JsonKey(name: 'url')
  final String url;
  
  /// The thumbnail URL of this Drive file.
  @JsonKey(name: 'thumbnailUrl')
  final String thumbnailUrl;
  
  @JsonKey(name: 'comment')
  final String comment;
  
  /// The parent folder ID of this Drive file.
  @JsonKey(name: 'folderId')
  final String folderId;
  
  /// The parent folder of this Drive file.
  @JsonKey(name: 'folder')
  final MisskeyDriveFolder folder;
  
  /// Owner ID of this Drive file.
  @JsonKey(name: 'userId')
  final String userId;
  
  /// Owner of this Drive file.
  @JsonKey(name: 'user')
  final MisskeyUser user;
  
  const MisskeyDriveFile({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.type,
    required this.md5,
    required this.size,
    required this.isSensitive,
    required this.blurhash,
    required this.properties,
    required this.url,
    required this.thumbnailUrl,
    required this.comment,
    required this.folderId,
    required this.folder,
    required this.userId,
    required this.user,
  });

  factory MisskeyDriveFile.fromJson(Map<String, dynamic> json) => _$MisskeyDriveFileFromJson(json);
  Map<String, dynamic> toJson() => _$MisskeyDriveFileToJson(this);
}
