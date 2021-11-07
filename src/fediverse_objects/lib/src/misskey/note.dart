import 'package:fediverse_objects/misskey.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'text')
  final String? text;

  @JsonKey(name: 'cw')
  final String? cw;

  @JsonKey(name: 'userId')
  final String userId;

  @JsonKey(name: 'user')
  final User user;

  @JsonKey(name: 'replyId')
  final String? replyId;

  @JsonKey(name: 'renoteId')
  final String? renoteId;

  @JsonKey(name: 'reply')
  final Note? reply;

  @JsonKey(name: 'renote')
  final Note? renote;

  @JsonKey(name: 'viaMobile')
  final bool? viaMobile;

  @JsonKey(name: 'isHidden')
  final bool? isHidden;

  @JsonKey(name: 'visibility')
  final String visibility;

  @JsonKey(name: 'mentions')
  final Iterable<String>? mentions;

  @JsonKey(name: 'visibleUserIds')
  final Iterable<String>? visibleUserIds;

  @JsonKey(name: 'fileIds')
  final Iterable<String>? fileIds;

  @JsonKey(name: 'files')
  final Iterable<DriveFile>? files;

  @JsonKey(name: 'tags')
  final Iterable<String>? tags;

  @JsonKey(name: 'poll')
  final Map<String, dynamic>? poll;

  @JsonKey(name: 'channelId')
  final String? channelId;

  @JsonKey(name: 'channel')
  final Channel? channel;

  @JsonKey(name: 'localOnly')
  final bool? localOnly;

  @JsonKey(name: 'emojis')
  final Iterable<Emoji> emojis;

  @JsonKey(name: 'reactions')
  final Map<String, dynamic> reactions;

  @JsonKey(name: 'renoteCount')
  final int renoteCount;

  @JsonKey(name: 'repliesCount')
  final int repliesCount;

  @JsonKey(name: 'uri')
  final String? uri;

  @JsonKey(name: 'url')
  final String? url;

  @JsonKey(name: 'myReaction')
  final String? myReaction;

  const Note({
    required this.id,
    required this.createdAt,
    this.text,
    this.cw,
    required this.userId,
    required this.user,
    this.replyId,
    this.renoteId,
    this.reply,
    this.renote,
    required this.viaMobile,
    required this.isHidden,
    required this.visibility,
    required this.mentions,
    required this.visibleUserIds,
    required this.fileIds,
    required this.files,
    required this.tags,
    this.poll,
    this.channelId,
    this.channel,
    required this.localOnly,
    required this.emojis,
    required this.reactions,
    required this.renoteCount,
    required this.repliesCount,
    required this.uri,
    required this.url,
    this.myReaction,
  });

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
