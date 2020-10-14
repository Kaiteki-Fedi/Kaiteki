import 'package:kaiteki/api/model/misskey/emoji.dart';
import 'package:kaiteki/api/model/misskey/note.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class MisskeyUser {
  final String id;

  final String username;

  final String name;

  final String url;

  final String avatarUrl;

  final String avatarBlurhash;

  final String bannerUrl;

  final String bannerBlurhash;

  final Iterable<MisskeyEmoji> emojis;

  final String host;

  final String description;

  final String birthday;

  final DateTime createdAt;

  final DateTime updatedAt;

  final String location;

  final int followersCount;

  final int followingCount;

  final int notesCount;

  final bool isBot;

  final Iterable<String> pinnedNoteIds;

  final Iterable<MisskeyNote> pinnedNotes;

  final bool isCat;

  final bool isAdmin;

  final bool isModerator;

  final bool isLocked;

  final bool hasUnreadSpecifiedNotes;

  final bool hasUnreadMentions;

  const MisskeyUser({
    this.id,
    this.username,
    this.name,
    this.url,
    this.avatarUrl,
    this.avatarBlurhash,
    this.bannerUrl,
    this.bannerBlurhash,
    this.emojis,
    this.host,
    this.description,
    this.birthday,
    this.createdAt,
    this.updatedAt,
    this.location,
    this.followersCount,
    this.followingCount,
    this.notesCount,
    this.isBot,
    this.pinnedNoteIds,
    this.pinnedNotes,
    this.isCat,
    this.isAdmin,
    this.isModerator,
    this.isLocked,
    this.hasUnreadSpecifiedNotes,
    this.hasUnreadMentions,
  });

  factory MisskeyUser.fromJson(Map<String, dynamic> json) => _$MisskeyUserFromJson(json);
}