// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyUser _$MisskeyUserFromJson(Map<String, dynamic> json) {
  return MisskeyUser(
    id: json['id'] as String,
    username: json['username'] as String,
    name: json['name'] as String,
    url: json['url'] as String,
    avatarUrl: json['avatarUrl'] as String,
    avatarBlurhash: json['avatarBlurhash'] as String,
    bannerUrl: json['bannerUrl'] as String,
    bannerBlurhash: json['bannerBlurhash'] as String,
    emojis: (json['emojis'] as List)?.map((e) =>
        e == null ? null : MisskeyEmoji.fromJson(e as Map<String, dynamic>)),
    host: json['host'] as String,
    description: json['description'] as String,
    birthday: json['birthday'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String),
    location: json['location'] as String,
    followersCount: json['followersCount'] as int,
    followingCount: json['followingCount'] as int,
    notesCount: json['notesCount'] as int,
    isBot: json['isBot'] as bool,
    pinnedNoteIds: (json['pinnedNoteIds'] as List)?.map((e) => e as String),
    pinnedNotes: (json['pinnedNotes'] as List)?.map((e) =>
        e == null ? null : MisskeyNote.fromJson(e as Map<String, dynamic>)),
    isCat: json['isCat'] as bool,
    isAdmin: json['isAdmin'] as bool,
    isModerator: json['isModerator'] as bool,
    isLocked: json['isLocked'] as bool,
    hasUnreadSpecifiedNotes: json['hasUnreadSpecifiedNotes'] as bool,
    hasUnreadMentions: json['hasUnreadMentions'] as bool,
  );
}
