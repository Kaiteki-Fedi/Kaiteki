// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      description: json['description'] as String?,
      url: json['url'] as String?,
      verified: json['verified'] as bool?,
      location: json['location'] as String?,
      pinnedTweetId: json['pinned_tweet_id'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      publicMetrics: json['public_metrics'] == null
          ? null
          : UserPublicMetrics.fromJson(
              json['public_metrics'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'created_at': instance.createdAt?.toIso8601String(),
      'description': instance.description,
      'url': instance.url,
      'verified': instance.verified,
      'location': instance.location,
      'pinned_tweet_id': instance.pinnedTweetId,
      'profile_image_url': instance.profileImageUrl,
      'public_metrics': instance.publicMetrics,
    };

UserPublicMetrics _$UserPublicMetricsFromJson(Map<String, dynamic> json) =>
    UserPublicMetrics(
      followersCount: json['followers_count'] as int?,
      followingCount: json['following_count'] as int?,
      tweetCount: json['tweet_count'] as int?,
      listedCount: json['listed_count'] as int?,
    );

Map<String, dynamic> _$UserPublicMetricsToJson(UserPublicMetrics instance) =>
    <String, dynamic>{
      'followers_count': instance.followersCount,
      'following_count': instance.followingCount,
      'tweet_count': instance.tweetCount,
      'listed_count': instance.listedCount,
    };
