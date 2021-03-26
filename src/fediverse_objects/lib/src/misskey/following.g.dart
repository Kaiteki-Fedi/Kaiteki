// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'following.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyFollowing _$MisskeyFollowingFromJson(Map<String, dynamic> json) {
  return MisskeyFollowing(
    id: json['id'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    followeeId: json['followeeId'] as String,
    followee: json['followee'] == null
        ? null
        : MisskeyUser.fromJson(json['followee'] as Map<String, dynamic>),
    followerId: json['followerId'] as String,
    follower: json['follower'] == null
        ? null
        : MisskeyUser.fromJson(json['follower'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MisskeyFollowingToJson(MisskeyFollowing instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'followeeId': instance.followeeId,
      'followee': instance.followee,
      'followerId': instance.followerId,
      'follower': instance.follower,
    };
