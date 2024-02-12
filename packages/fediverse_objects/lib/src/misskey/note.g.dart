// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Note',
      json,
      ($checkedConvert) {
        final val = Note(
          id: $checkedConvert('id', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          text: $checkedConvert('text', (v) => v as String?),
          cw: $checkedConvert('cw', (v) => v as String?),
          userId: $checkedConvert('userId', (v) => v as String),
          user: $checkedConvert(
              'user', (v) => User.fromJson(v as Map<String, dynamic>)),
          replyId: $checkedConvert('replyId', (v) => v as String?),
          renoteId: $checkedConvert('renoteId', (v) => v as String?),
          reply: $checkedConvert(
              'reply',
              (v) =>
                  v == null ? null : Note.fromJson(v as Map<String, dynamic>)),
          renote: $checkedConvert(
              'renote',
              (v) =>
                  v == null ? null : Note.fromJson(v as Map<String, dynamic>)),
          isHidden: $checkedConvert('isHidden', (v) => v as bool?),
          visibility: $checkedConvert('visibility', (v) => v as String),
          mentions: $checkedConvert('mentions',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
          visibleUserIds: $checkedConvert('visibleUserIds',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
          fileIds: $checkedConvert('fileIds',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
          files: $checkedConvert(
              'files',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => DriveFile.fromJson(e as Map<String, dynamic>))
                  .toList()),
          tags: $checkedConvert('tags',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
          poll: $checkedConvert(
              'poll',
              (v) =>
                  v == null ? null : Poll.fromJson(v as Map<String, dynamic>)),
          channelId: $checkedConvert('channelId', (v) => v as String?),
          channel:
              $checkedConvert('channel', (v) => v as Map<String, dynamic>?),
          localOnly: $checkedConvert('localOnly', (v) => v as bool?),
          emojis: $checkedConvert(
            'emojis',
            (v) => (v as List<dynamic>?)
                ?.map((e) => Emoji.fromJson(e as Map<String, dynamic>))
                .toList(),
            readValue: misskeyEmojisReadValue,
          ),
          reactions: $checkedConvert(
              'reactions', (v) => Map<String, int>.from(v as Map)),
          renoteCount: $checkedConvert('renoteCount', (v) => v as int),
          repliesCount: $checkedConvert('repliesCount', (v) => v as int),
          uri: $checkedConvert(
              'uri', (v) => v == null ? null : Uri.parse(v as String)),
          url: $checkedConvert(
              'url', (v) => v == null ? null : Uri.parse(v as String)),
          myReaction: $checkedConvert('myReaction', (v) => v as String?),
        );
        return val;
      },
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
      'isHidden': instance.isHidden,
      'visibility': instance.visibility,
      'mentions': instance.mentions,
      'visibleUserIds': instance.visibleUserIds,
      'fileIds': instance.fileIds,
      'files': instance.files,
      'tags': instance.tags,
      'poll': instance.poll,
      'channelId': instance.channelId,
      'channel': instance.channel,
      'localOnly': instance.localOnly,
      'emojis': instance.emojis,
      'reactions': instance.reactions,
      'renoteCount': instance.renoteCount,
      'repliesCount': instance.repliesCount,
      'uri': instance.uri?.toString(),
      'url': instance.url?.toString(),
      'myReaction': instance.myReaction,
    };
