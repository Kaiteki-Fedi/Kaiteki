// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Channel _$ChannelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Channel',
      json,
      ($checkedConvert) {
        final val = Channel(
          id: $checkedConvert('id', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          lastNotedAt: $checkedConvert('lastNotedAt',
              (v) => v == null ? null : DateTime.parse(v as String)),
          name: $checkedConvert('name', (v) => v as String),
          description: $checkedConvert('description', (v) => v as String?),
          bannerUrl: $checkedConvert('bannerUrl', (v) => v as String?),
          notesCount: $checkedConvert('notesCount', (v) => v as int),
          usersCount: $checkedConvert('usersCount', (v) => v as int),
          isFollowing: $checkedConvert('isFollowing', (v) => v as bool?),
          userId: $checkedConvert('userId', (v) => v as String?),
        );
        return val;
      },
    );

Map<String, dynamic> _$ChannelToJson(Channel instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastNotedAt': instance.lastNotedAt?.toIso8601String(),
      'name': instance.name,
      'description': instance.description,
      'bannerUrl': instance.bannerUrl,
      'notesCount': instance.notesCount,
      'usersCount': instance.usersCount,
      'isFollowing': instance.isFollowing,
      'userId': instance.userId,
    };
