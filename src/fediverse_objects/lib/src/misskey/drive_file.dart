import 'package:fediverse_objects/src/misskey/drive_folder.dart';
import 'package:fediverse_objects/src/misskey/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'drive_file.g.dart';

@JsonSerializable()
class DriveFile {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'md5')
  final String md5;

  @JsonKey(name: 'size')
  final int size;

  @JsonKey(name: 'isSensitive')
  final bool isSensitive;

  @JsonKey(name: 'blurhash')
  final String? blurhash;

  @JsonKey(name: 'properties')
  final Map<String, dynamic> properties;

  @JsonKey(name: 'url')
  final String? url;

  @JsonKey(name: 'thumbnailUrl')
  final String? thumbnailUrl;

  @JsonKey(name: 'comment')
  final String? comment;

  @JsonKey(name: 'folderId')
  final String? folderId;

  @JsonKey(name: 'folder')
  final DriveFolder? folder;

  @JsonKey(name: 'userId')
  final String? userId;

  @JsonKey(name: 'user')
  final User? user;

  const DriveFile({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.type,
    required this.md5,
    required this.size,
    required this.isSensitive,
    this.blurhash,
    required this.properties,
    this.url,
    this.thumbnailUrl,
    this.comment,
    this.folderId,
    this.folder,
    this.userId,
    this.user,
  });

  factory DriveFile.fromJson(Map<String, dynamic> json) =>
      _$DriveFileFromJson(json);

  Map<String, dynamic> toJson() => _$DriveFileToJson(this);
}
