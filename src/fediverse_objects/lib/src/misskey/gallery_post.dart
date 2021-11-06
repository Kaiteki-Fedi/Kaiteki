import 'package:fediverse_objects/src/misskey/drive_file.dart';
import 'package:fediverse_objects/src/misskey/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gallery_post.g.dart';

@JsonSerializable()
class GalleryPost {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'userId')
  final String userId;

  @JsonKey(name: 'user')
  final User user;

  @JsonKey(name: 'fileIds')
  final Iterable<String>? fileIds;

  @JsonKey(name: 'files')
  final Iterable<DriveFile>? files;

  @JsonKey(name: 'tags')
  final Iterable<String>? tags;

  @JsonKey(name: 'isSensitive')
  final bool isSensitive;

  const GalleryPost({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    this.description,
    required this.userId,
    required this.user,
    required this.fileIds,
    required this.files,
    required this.tags,
    required this.isSensitive,
  });

  factory GalleryPost.fromJson(Map<String, dynamic> json) =>
      _$GalleryPostFromJson(json);

  Map<String, dynamic> toJson() => _$GalleryPostToJson(this);
}
