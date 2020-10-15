// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyChannel _$MisskeyChannelFromJson(Map<String, dynamic> json) {
  return MisskeyChannel(
    id: json['id'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    lastNotedAt: json['lastNotedAt'] == null
        ? null
        : DateTime.parse(json['lastNotedAt'] as String),
    name: json['name'] as String,
    description: json['description'] as String,
    bannerUrl: json['bannerUrl'] as String,
    notesCount: json['notesCount'] as int,
    usersCount: json['usersCount'] as int,
    isFollowing: json['isFollowing'] as bool,
    userId: json['userId'] as String,
  );
}
