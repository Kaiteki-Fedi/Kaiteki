// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'following_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FollowingRequest _$FollowingRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'FollowingRequest',
      json,
      ($checkedConvert) {
        final val = FollowingRequest(
          id: $checkedConvert('id', (v) => v as String),
          follower: $checkedConvert(
              'follower', (v) => User.fromJson(v as Map<String, dynamic>)),
          followee: $checkedConvert(
              'followee', (v) => User.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$FollowingRequestToJson(FollowingRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'follower': instance.follower,
      'followee': instance.followee,
    };
