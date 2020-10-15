import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/api/model/misskey/channel.dart';
import 'package:kaiteki/api/model/misskey/emoji.dart';
import 'package:kaiteki/api/model/misskey/file.dart';
import 'package:kaiteki/api/model/misskey/user.dart';
part 'note.g.dart';

@JsonSerializable(createToJson: false)
class MisskeyNote {
  final String id;

  final DateTime createdAt;

  final String text;

  final String cw;

  final String userId;

  final MisskeyUser user;

  final String replyId;

  final String renoteId;

  final MisskeyNote reply;

  final MisskeyNote renote;

  final bool viaMobile;

  final bool isHidden;

  final String visibility;

  final Iterable<String> mentions;

  final Iterable<String> visibleUserIds;

  final Iterable<String> fileIds;

  final Iterable<MisskeyFile> files;

  final Iterable<String> tags;

  final dynamic poll;

  final String channelId;

  final MisskeyChannel channel;

  final String myReaction;

  final Map<String, int> reactions;

  final Iterable<MisskeyEmoji> emojis;

  const MisskeyNote({
    this.id,
    this.createdAt,
    this.text,
    this.cw,
    this.userId,
    this.user,
    this.replyId,
    this.renoteId,
    this.reply,
    this.renote,
    this.viaMobile,
    this.isHidden,
    this.visibility,
    this.mentions,
    this.visibleUserIds,
    this.fileIds,
    this.files,
    this.tags,
    this.poll,
    this.channelId,
    this.channel,
    this.myReaction,
    this.reactions,
    this.emojis,
  });

  factory MisskeyNote.fromJson(Map<String, dynamic> json) => _$MisskeyNoteFromJson(json);
}