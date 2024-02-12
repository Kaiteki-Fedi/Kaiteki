import 'package:json_annotation/json_annotation.dart';
import 'drive_folder.dart';
import 'user.dart';
part 'drive_file.g.dart';

@JsonSerializable()
class DriveFile {
  final String id;

  final DateTime createdAt;

  final String name;

  final String type;

  final String md5;

  final int size;

  final bool isSensitive;

  final String? blurhash;

  final Map<String, dynamic> properties;

  final String? url;

  final String? thumbnailUrl;

  final String? comment;

  final String? folderId;

  final DriveFolder? folder;

  final String? userId;

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
