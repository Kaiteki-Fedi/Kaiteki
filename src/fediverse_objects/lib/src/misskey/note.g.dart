// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      text: json['text'] as String?,
      cw: json['cw'] as String?,
      userId: json['userId'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      replyId: json['replyId'] as String?,
      renoteId: json['renoteId'] as String?,
      reply: json['reply'] == null
          ? null
          : Note.fromJson(json['reply'] as Map<String, dynamic>),
      renote: json['renote'] == null
          ? null
          : Note.fromJson(json['renote'] as Map<String, dynamic>),
      viaMobile: json['viaMobile'] as bool?,
      isHidden: json['isHidden'] as bool?,
      visibility: json['visibility'] as String,
      mentions: (json['mentions'] as List<dynamic>?)?.map((e) => e as String),
      visibleUserIds:
          (json['visibleUserIds'] as List<dynamic>?)?.map((e) => e as String),
      fileIds: (json['fileIds'] as List<dynamic>?)?.map((e) => e as String),
      files: (json['files'] as List<dynamic>?)
          ?.map((e) => DriveFile.fromJson(e as Map<String, dynamic>)),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String),
      poll: json['poll'] as Map<String, dynamic>?,
      channelId: json['channelId'] as String?,
      channel: json['channel'] == null
          ? null
          : Channel.fromJson(json['channel'] as Map<String, dynamic>),
      localOnly: json['localOnly'] as bool?,
      emojis: (json['emojis'] as List<dynamic>)
          .map((e) => Emoji.fromJson(e as Map<String, dynamic>)),
      reactions: json['reactions'] as Map<String, dynamic>,
      renoteCount: json['renoteCount'] as int,
      repliesCount: json['repliesCount'] as int,
      uri: json['uri'] as String?,
      url: json['url'] as String?,
      myReaction: json['myReaction'] as String?,
    );

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
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
      'mentions': instance.mentions?.toList(),
      'visibleUserIds': instance.visibleUserIds?.toList(),
      'fileIds': instance.fileIds?.toList(),
      'files': instance.files?.toList(),
      'tags': instance.tags?.toList(),
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
      'myReaction': instance.myReaction,
    };
