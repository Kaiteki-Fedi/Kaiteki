import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/fediverse/backends/twitter/v1/model/date_format.dart";
import "package:kaiteki/fediverse/backends/twitter/v1/model/entities/entities.dart";
import "package:kaiteki/utils/utils.dart";

part "user.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  final String screenName;
  final String name;
  final String description;
  final String? location;
  final String idStr;
  final String profileImageUrlHttps;
  final String? profileBannerUrl;

  @JsonKey(name: "created_at")
  final String createdAtStr;

  @JsonKey(ignore: true)
  DateTime get createdAt => twitterDateFormat.parse(createdAtStr);

  /// A URL provided by the user in association with their profile.
  final String? url;

  final bool protected;
  final bool verified;
  final int friendsCount;
  final int listedCount;
  final int? favoritesCount;
  final int followersCount;
  final int statusesCount;

  /// When true, indicates that the user has not altered the theme or
  /// background of their user profile.
  final bool defaultProfile;

  final bool defaultProfileImage;

  /// When present, indicates a list of uppercase two-letter country codes this
  /// content is withheld from.
  ///
  /// Twitter supports the following non-country
  /// values for this field:
  ///
  /// - “XX” - Content is withheld in all countries
  /// - “XY” - Content is withheld due to a DMCA request.
  final List<String>? withheldInCountries;

  final UserEntities entities;

  const User({
    required this.screenName,
    required this.name,
    required this.description,
    required this.idStr,
    required this.location,
    required this.profileImageUrlHttps,
    required this.profileBannerUrl,
    required this.url,
    required this.protected,
    required this.verified,
    required this.friendsCount,
    required this.listedCount,
    required this.favoritesCount,
    required this.followersCount,
    required this.statusesCount,
    required this.defaultProfile,
    required this.defaultProfileImage,
    required this.withheldInCountries,
    required this.createdAtStr,
    required this.entities,
  });

  factory User.fromJson(JsonMap json) => _$UserFromJson(json);

  JsonMap toJson() => _$UserToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UserEntities {
  final Entities? url;
  final Entities description;

  const UserEntities({
    required this.url,
    required this.description,
  });

  factory UserEntities.fromJson(JsonMap json) => _$UserEntitiesFromJson(json);

  JsonMap toJson() => _$UserEntitiesToJson(this);
}
