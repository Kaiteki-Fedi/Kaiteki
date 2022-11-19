// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tweet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tweet _$TweetFromJson(Map<String, dynamic> json) => Tweet(
      createdAtStr: json['created_at'] as String,
      entities: Entities.fromJson(json['entities'] as Map<String, dynamic>),
      favoriteCount: json['favorite_count'] as int,
      favorited: json['favorited'] as bool,
      idStr: json['id_str'] as String,
      inReplyToStatusIdStr: json['in_reply_to_status_id_str'] as String?,
      inReplyToUserIdStr: json['in_reply_to_user_id_str'] as String?,
      lang: json['lang'] as String,
      quotedStatus: json['quoted_status'] == null
          ? null
          : Tweet.fromJson(json['quoted_status'] as Map<String, dynamic>),
      retweetCount: json['retweet_count'] as int,
      retweeted: json['retweeted'] as bool,
      text: json['text'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      retweetedStatus: json['retweeted_status'] == null
          ? null
          : Tweet.fromJson(json['retweeted_status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TweetToJson(Tweet instance) => <String, dynamic>{
      'created_at': instance.createdAtStr,
      'favorited': instance.favorited,
      'retweeted': instance.retweeted,
      'entities': instance.entities,
      'favorite_count': instance.favoriteCount,
      'retweet_count': instance.retweetCount,
      'id_str': instance.idStr,
      'in_reply_to_status_id_str': instance.inReplyToStatusIdStr,
      'in_reply_to_user_id_str': instance.inReplyToUserIdStr,
      'lang': instance.lang,
      'text': instance.text,
      'quoted_status': instance.quotedStatus,
      'retweeted_status': instance.retweetedStatus,
      'user': instance.user,
    };
