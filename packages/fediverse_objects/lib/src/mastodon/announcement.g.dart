// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'Announcement',
      json,
      ($checkedConvert) {
        final val = Announcement(
          id: $checkedConvert('id', (v) => v as String),
          content: $checkedConvert('content', (v) => v as String),
          startsAt: $checkedConvert('starts_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          endsAt: $checkedConvert(
              'ends_at', (v) => v == null ? null : DateTime.parse(v as String)),
          updatedAt: $checkedConvert('updated_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          createdAt: $checkedConvert('created_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          allDay: $checkedConvert('all_day', (v) => v as bool),
          read: $checkedConvert('read', (v) => v as bool?),
          mentions: $checkedConvert(
              'mentions',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      AnnouncementAccount.fromJson(e as Map<String, dynamic>))
                  .toList()),
          statuses: $checkedConvert(
              'statuses',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      AnnouncementStatus.fromJson(e as Map<String, dynamic>))
                  .toList()),
          tags: $checkedConvert(
              'tags',
              (v) => (v as List<dynamic>)
                  .map((e) => Tag.fromJson(e as Map<String, dynamic>))
                  .toList()),
          emojis: $checkedConvert(
              'emojis',
              (v) => (v as List<dynamic>)
                  .map((e) => CustomEmoji.fromJson(e as Map<String, dynamic>))
                  .toList()),
          reactions: $checkedConvert(
              'reactions',
              (v) => (v as List<dynamic>)
                  .map((e) => Reaction.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'startsAt': 'starts_at',
        'endsAt': 'ends_at',
        'updatedAt': 'updated_at',
        'createdAt': 'created_at',
        'allDay': 'all_day'
      },
    );

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'starts_at': instance.startsAt?.toIso8601String(),
      'ends_at': instance.endsAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'all_day': instance.allDay,
      'read': instance.read,
      'mentions': instance.mentions,
      'statuses': instance.statuses,
      'tags': instance.tags,
      'emojis': instance.emojis,
      'reactions': instance.reactions,
    };
