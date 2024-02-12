// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'following.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Following _$FollowingFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Following',
      json,
      ($checkedConvert) {
        final val = Following(
          id: $checkedConvert('id', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          followeeId: $checkedConvert('followeeId', (v) => v as String),
          followee: $checkedConvert('followee', (v) => v),
          followerId: $checkedConvert('followerId', (v) => v as String),
          follower: $checkedConvert('follower', (v) => v),
        );
        return val;
      },
    );

Map<String, dynamic> _$FollowingToJson(Following instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'followeeId': instance.followeeId,
      'followee': instance.followee,
      'followerId': instance.followerId,
      'follower': instance.follower,
    };
