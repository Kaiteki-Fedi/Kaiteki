// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyFile _$MisskeyFileFromJson(Map<String, dynamic> json) {
  return MisskeyFile(
    id: json['id'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    name: json['name'] as String,
    type: json['type'] as String,
    md5: json['md5'] as String,
    size: json['size'] as int,
    url: json['url'] as String,
    folderId: json['folderId'] as String,
    isSensitive: json['isSensitive'] as bool,
  );
}
