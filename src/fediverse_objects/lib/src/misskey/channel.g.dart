// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Channel _$ChannelFromJson(Map<String, dynamic> json) => Channel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastNotedAt: json['lastNotedAt'] == null
          ? null
          : DateTime.parse(json['lastNotedAt'] as String),
      name: json['name'] as String,
      description: json['description'] as String?,
      bannerUrl: json['bannerUrl'] as String?,
      notesCount: json['notesCount'] as int,
      usersCount: json['usersCount'] as int,
      isFollowing: json['isFollowing'] as bool?,
      userId: json['userId'] as String?,
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
