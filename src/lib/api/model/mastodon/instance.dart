import 'package:json_annotation/json_annotation.dart';
part 'instance.g.dart';

@JsonSerializable()
class MastodonInstance {
  @JsonKey(name: "avatar_upload_limit")
  final int avatarUploadLimit;

  @JsonKey(name: "background_image")
  final String backgroundImage;

  @JsonKey(name: "background_upload_limit")
  final int backgroundUploadLimit;

  @JsonKey(name: "banner_upload_limit")
  final int bannerUploadLimit;

  final String description;

  final String email;

  final Iterable<String> languages;

  @JsonKey(name: "max_toot_chars")
  final int maxTootChars;

  @JsonKey(name: "poll_limits")
  final dynamic pollLimits;

  final bool registrations;

  final dynamic stats;

  final String thumbnail;

  final String title;

  @JsonKey(name: "upload_limit")
  final int uploadLimit;

  final String uri;

  final dynamic urls;

  final String version;

  const MastodonInstance({
    this.avatarUploadLimit,
    this.backgroundImage,
    this.backgroundUploadLimit,
    this.bannerUploadLimit,
    this.description,
    this.email,
    this.languages,
    this.maxTootChars,
    this.pollLimits,
    this.registrations,
    this.stats,
    this.thumbnail,
    this.title,
    this.uploadLimit,
    this.uri,
    this.urls,
    this.version,
  });

  factory MastodonInstance.fromJson(Map<String, dynamic> json) => _$MastodonInstanceFromJson(json);
}