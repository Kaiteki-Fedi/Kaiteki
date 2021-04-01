import 'package:fediverse_objects/src/misskey/emoji.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/src/misskey/user.dart';
import 'package:fediverse_objects/src/misskey/drive_file.dart';
import 'package:fediverse_objects/src/misskey/channel.dart';
part 'note.g.dart';

@JsonSerializable()
class MisskeyNote {
  /// The unique identifier for this Note.
  @JsonKey(name: 'id')
  final String id;

  /// The date that the Note was created on Misskey.
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'text')
  final String text;

  @JsonKey(name: 'cw')
  final String cw;

  @JsonKey(name: 'userId')
  final String userId;

  @JsonKey(name: 'user')
  final MisskeyUser user;

  @JsonKey(name: 'replyId')
  final String replyId;

  @JsonKey(name: 'renoteId')
  final String renoteId;

  @JsonKey(name: 'reply')
  final MisskeyNote reply;

  @JsonKey(name: 'renote')
  final MisskeyNote renote;

  @JsonKey(name: 'viaMobile')
  final bool viaMobile;

  @JsonKey(name: 'isHidden')
  final bool isHidden;

  @JsonKey(name: 'visibility')
  final String visibility;

  @JsonKey(name: 'mentions')
  final Iterable<String> mentions;

  @JsonKey(name: 'visibleUserIds')
  final Iterable<String> visibleUserIds;

  @JsonKey(name: 'fileIds')
  final Iterable<String> fileIds;

  @JsonKey(name: 'files')
  final Iterable<MisskeyDriveFile> files;

  @JsonKey(name: 'tags')
  final Iterable<String> tags;

  @JsonKey(name: 'poll')
  final Map<String, dynamic> poll;

  @JsonKey(name: 'channelId')
  final String channelId;

  @JsonKey(name: 'channel')
  final MisskeyChannel channel;

  @JsonKey(name: 'localOnly')
  final bool localOnly;

  @JsonKey(name: 'emojis')
  final Iterable<MisskeyEmoji> emojis;

  /// Key is either Unicode emoji or custom emoji, value is count of that emoji reaction.
  @JsonKey(name: 'reactions')
  final Map<String, dynamic> reactions;

  @JsonKey(name: 'renoteCount')
  final int renoteCount;

  @JsonKey(name: 'repliesCount')
  final int repliesCount;

  /// The URI of a note. it will be null when the note is local.
  @JsonKey(name: 'uri')
  final String uri;

  /// The human readable url of a note. it will be null when the note is local.
  @JsonKey(name: 'url')
  final String url;

  @JsonKey(name: '_featuredId_')
  final String featuredId_;

  @JsonKey(name: '_prId_')
  final String prId_;

  /// Key is either Unicode emoji or custom emoji, value is count of that emoji reaction.
  @JsonKey(name: 'myReaction')
  final Map<String, dynamic> myReaction;

  const MisskeyNote({
    required this.id,
    required this.createdAt,
    required this.text,
    required this.cw,
    required this.userId,
    required this.user,
    required this.replyId,
    required this.renoteId,
    required this.reply,
    required this.renote,
    required this.viaMobile,
    required this.isHidden,
    required this.visibility,
    required this.mentions,
    required this.visibleUserIds,
    required this.fileIds,
    required this.files,
    required this.tags,
    required this.poll,
    required this.channelId,
    required this.channel,
    required this.localOnly,
    required this.emojis,
    required this.reactions,
    required this.renoteCount,
    required this.repliesCount,
    required this.uri,
    required this.url,
    required this.featuredId_,
    required this.prId_,
    required this.myReaction,
  });

  factory MisskeyNote.fromJson(Map<String, dynamic> json) =>
      _$MisskeyNoteFromJson(json);
  Map<String, dynamic> toJson() => _$MisskeyNoteToJson(this);
}
