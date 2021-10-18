// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'following.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Following _$FollowingFromJson(Map<String, dynamic> json) {
  return Following(
    id: json['id'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    followeeId: json['followeeId'] as String,
    followee: User.fromJson(json['followee'] as Map<String, dynamic>),
    followerId: json['followerId'] as String,
    follower: User.fromJson(json['follower'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$FollowingToJson(Following instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'followeeId': instance.followeeId,
      'followee': instance.followee,
      'followerId': instance.followerId,
      'follower': instance.follower,
    };
