import 'package:json_annotation/json_annotation.dart';
part 'file.g.dart';

@JsonSerializable(createToJson: false)
class MisskeyFile {
  final String id;

  final DateTime createdAt;

  final String name;

  final String type;

  final String md5;

  final int size;

  final String url;

  final String folderId;

  final bool isSensitive;

  const MisskeyFile({
    this.id,
    this.createdAt,
    this.name,
    this.type,
    this.md5,
    this.size,
    this.url,
    this.folderId,
    this.isSensitive,
  });

  factory MisskeyFile.fromJson(Map<String, dynamic> json) => _$MisskeyFileFromJson(json);
}