// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      screenName: json['screen_name'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      idStr: json['id_str'] as String,
      location: json['location'] as String?,
      profileImageUrlHttps: json['profile_image_url_https'] as String,
      profileBannerUrl: json['profile_banner_url'] as String?,
      url: json['url'] as String?,
      protected: json['protected'] as bool,
      verified: json['verified'] as bool,
      friendsCount: json['friends_count'] as int,
      listedCount: json['listed_count'] as int,
      favoritesCount: json['favorites_count'] as int?,
      followersCount: json['followers_count'] as int,
      statusesCount: json['statuses_count'] as int,
      defaultProfile: json['default_profile'] as bool,
      defaultProfileImage: json['default_profile_image'] as bool,
      withheldInCountries: (json['withheld_in_countries'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAtStr: json['created_at'] as String,
      entities: UserEntities.fromJson(json['entities'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'screen_name': instance.screenName,
      'name': instance.name,
      'description': instance.description,
      'location': instance.location,
      'id_str': instance.idStr,
      'profile_image_url_https': instance.profileImageUrlHttps,
      'profile_banner_url': instance.profileBannerUrl,
      'created_at': instance.createdAtStr,
      'url': instance.url,
      'protected': instance.protected,
      'verified': instance.verified,
      'friends_count': instance.friendsCount,
      'listed_count': instance.listedCount,
      'favorites_count': instance.favoritesCount,
      'followers_count': instance.followersCount,
      'statuses_count': instance.statusesCount,
      'default_profile': instance.defaultProfile,
      'default_profile_image': instance.defaultProfileImage,
      'withheld_in_countries': instance.withheldInCountries,
      'entities': instance.entities,
    };

UserEntities _$UserEntitiesFromJson(Map<String, dynamic> json) => UserEntities(
      url: json['url'] == null
          ? null
          : Entities.fromJson(json['url'] as Map<String, dynamic>),
      description:
          Entities.fromJson(json['description'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserEntitiesToJson(UserEntities instance) =>
    <String, dynamic>{
      'url': instance.url,
      'description': instance.description,
    };
