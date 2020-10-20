// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MastodonInstance _$MastodonInstanceFromJson(Map<String, dynamic> json) {
  return MastodonInstance(
    avatarUploadLimit: json['avatar_upload_limit'] as int,
    backgroundImage: json['background_image'] as String,
    backgroundUploadLimit: json['background_upload_limit'] as int,
    bannerUploadLimit: json['banner_upload_limit'] as int,
    description: json['description'] as String,
    email: json['email'] as String,
    languages: (json['languages'] as List)?.map((e) => e as String),
    maxTootChars: json['max_toot_chars'] as int,
    pollLimits: json['poll_limits'],
    registrations: json['registrations'] as bool,
    stats: json['stats'],
    thumbnail: json['thumbnail'] as String,
    title: json['title'] as String,
    uploadLimit: json['upload_limit'] as int,
    uri: json['uri'] as String,
    urls: json['urls'],
    version: json['version'] as String,
  );
}
