// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyNote _$MisskeyNoteFromJson(Map<String, dynamic> json) {
  return MisskeyNote(
    id: json['id'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    text: json['text'] as String,
    cw: json['cw'] as String,
    userId: json['userId'] as String,
    user: MisskeyUser.fromJson(json['user'] as Map<String, dynamic>),
    replyId: json['replyId'] as String,
    renoteId: json['renoteId'] as String,
    reply: MisskeyNote.fromJson(json['reply'] as Map<String, dynamic>),
    renote: MisskeyNote.fromJson(json['renote'] as Map<String, dynamic>),
    viaMobile: json['viaMobile'] as bool,
    isHidden: json['isHidden'] as bool,
    visibility: json['visibility'] as String,
    mentions: (json['mentions'] as List<dynamic>).map((e) => e as String),
    visibleUserIds:
        (json['visibleUserIds'] as List<dynamic>).map((e) => e as String),
    fileIds: (json['fileIds'] as List<dynamic>).map((e) => e as String),
    files: (json['files'] as List<dynamic>)
        .map((e) => MisskeyDriveFile.fromJson(e as Map<String, dynamic>)),
    tags: (json['tags'] as List<dynamic>).map((e) => e as String),
    poll: json['poll'] as Map<String, dynamic>,
    channelId: json['channelId'] as String,
    channel: MisskeyChannel.fromJson(json['channel'] as Map<String, dynamic>),
    localOnly: json['localOnly'] as bool,
    emojis: (json['emojis'] as List<dynamic>)
        .map((e) => MisskeyEmoji.fromJson(e as Map<String, dynamic>)),
    reactions: json['reactions'] as Map<String, dynamic>,
    renoteCount: json['renoteCount'] as int,
    repliesCount: json['repliesCount'] as int,
    uri: json['uri'] as String,
    url: json['url'] as String,
    featuredId_: json['_featuredId_'] as String,
    prId_: json['_prId_'] as String,
    myReaction: json['myReaction'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$MisskeyNoteToJson(MisskeyNote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'text': instance.text,
      'cw': instance.cw,
      'userId': instance.userId,
      'user': instance.user,
      'replyId': instance.replyId,
      'renoteId': instance.renoteId,
      'reply': instance.reply,
      'renote': instance.renote,
      'viaMobile': instance.viaMobile,
      'isHidden': instance.isHidden,
      'visibility': instance.visibility,
      'mentions': instance.mentions.toList(),
      'visibleUserIds': instance.visibleUserIds.toList(),
      'fileIds': instance.fileIds.toList(),
      'files': instance.files.toList(),
      'tags': instance.tags.toList(),
      'poll': instance.poll,
      'channelId': instance.channelId,
      'channel': instance.channel,
      'localOnly': instance.localOnly,
      'emojis': instance.emojis.toList(),
      'reactions': instance.reactions,
      'renoteCount': instance.renoteCount,
      'repliesCount': instance.repliesCount,
      'uri': instance.uri,
      'url': instance.url,
      '_featuredId_': instance.featuredId_,
      '_prId_': instance.prId_,
      'myReaction': instance.myReaction,
    };
