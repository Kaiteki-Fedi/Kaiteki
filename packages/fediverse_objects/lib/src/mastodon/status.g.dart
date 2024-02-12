// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Status _$StatusFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Status',
      json,
      ($checkedConvert) {
        final val = Status(
          account: $checkedConvert(
              'account', (v) => Account.fromJson(v as Map<String, dynamic>)),
          application: $checkedConvert(
              'application',
              (v) => v == null
                  ? null
                  : Application.fromJson(v as Map<String, dynamic>)),
          content: $checkedConvert('content', (v) => v as String),
          createdAt:
              $checkedConvert('created_at', (v) => DateTime.parse(v as String)),
          emojis: $checkedConvert(
              'emojis',
              (v) => (v as List<dynamic>)
                  .map((e) => CustomEmoji.fromJson(e as Map<String, dynamic>))
                  .toList()),
          favouritesCount: $checkedConvert('favourites_count', (v) => v as int),
          id: $checkedConvert('id', (v) => v as String),
          mediaAttachments: $checkedConvert(
              'media_attachments',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      MediaAttachment.fromJson(e as Map<String, dynamic>))
                  .toList()),
          mentions: $checkedConvert(
              'mentions',
              (v) => (v as List<dynamic>)
                  .map((e) => Mention.fromJson(e as Map<String, dynamic>))
                  .toList()),
          reblogsCount: $checkedConvert('reblogs_count', (v) => v as int),
          repliesCount: $checkedConvert('replies_count', (v) => v as int),
          sensitive: $checkedConvert('sensitive', (v) => v as bool),
          spoilerText: $checkedConvert('spoiler_text', (v) => v as String),
          tags: $checkedConvert(
              'tags',
              (v) => (v as List<dynamic>)
                  .map((e) => Tag.fromJson(e as Map<String, dynamic>))
                  .toList()),
          uri: $checkedConvert('uri', (v) => v as String),
          visibility: $checkedConvert('visibility', (v) => v as String),
          bookmarked: $checkedConvert('bookmarked', (v) => v as bool?),
          card: $checkedConvert(
              'card',
              (v) => v == null
                  ? null
                  : PreviewCard.fromJson(v as Map<String, dynamic>)),
          favourited: $checkedConvert('favourited', (v) => v as bool?),
          inReplyToAccountId:
              $checkedConvert('in_reply_to_account_id', (v) => v as String?),
          inReplyToId: $checkedConvert('in_reply_to_id', (v) => v as String?),
          language: $checkedConvert('language', (v) => v as String?),
          muted: $checkedConvert('muted', (v) => v as bool?),
          pinned: $checkedConvert('pinned', (v) => v as bool?),
          pleroma: $checkedConvert(
              'pleroma',
              (v) => v == null
                  ? null
                  : PleromaStatus.fromJson(v as Map<String, dynamic>)),
          reblog: $checkedConvert(
              'reblog',
              (v) => v == null
                  ? null
                  : Status.fromJson(v as Map<String, dynamic>)),
          reblogged: $checkedConvert('reblogged', (v) => v as bool?),
          url: $checkedConvert('url', (v) => v as String?),
          text: $checkedConvert('text', (v) => v as String?),
          poll: $checkedConvert(
              'poll',
              (v) =>
                  v == null ? null : Poll.fromJson(v as Map<String, dynamic>)),
          reactions: $checkedConvert(
              'reactions',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => Reaction.fromJson(e as Map<String, dynamic>))),
          quote: $checkedConvert(
              'quote',
              (v) => v == null
                  ? null
                  : Status.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {
        'createdAt': 'created_at',
        'favouritesCount': 'favourites_count',
        'mediaAttachments': 'media_attachments',
        'reblogsCount': 'reblogs_count',
        'repliesCount': 'replies_count',
        'spoilerText': 'spoiler_text',
        'inReplyToAccountId': 'in_reply_to_account_id',
        'inReplyToId': 'in_reply_to_id'
      },
    );

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
      'account': instance.account,
      'application': instance.application,
      'bookmarked': instance.bookmarked,
      'card': instance.card,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'emojis': instance.emojis,
      'favourited': instance.favourited,
      'favourites_count': instance.favouritesCount,
      'id': instance.id,
      'in_reply_to_account_id': instance.inReplyToAccountId,
      'in_reply_to_id': instance.inReplyToId,
      'language': instance.language,
      'media_attachments': instance.mediaAttachments,
      'mentions': instance.mentions,
      'muted': instance.muted,
      'pinned': instance.pinned,
      'pleroma': instance.pleroma,
      'reblog': instance.reblog,
      'reblogged': instance.reblogged,
      'reblogs_count': instance.reblogsCount,
      'replies_count': instance.repliesCount,
      'poll': instance.poll,
      'sensitive': instance.sensitive,
      'spoiler_text': instance.spoilerText,
      'tags': instance.tags,
      'uri': instance.uri,
      'url': instance.url,
      'visibility': instance.visibility,
      'text': instance.text,
      'reactions': instance.reactions?.toList(),
      'quote': instance.quote,
    };
