import 'package:fediverse_objects/src/mastodon/account.dart';
import 'package:fediverse_objects/src/mastodon/instance_statistics.dart';
import 'package:fediverse_objects/src/mastodon/instance_urls.dart';
import 'package:json_annotation/json_annotation.dart';

part 'instance.g.dart';

@JsonSerializable()
class MastodonInstance {
  /// (Added by Pleroma)
  @JsonKey(name: 'avatar_upload_limit')
  final int? avatarUploadLimit;

  /// (Added by Pleroma)
  @JsonKey(name: 'background_image')
  final String? backgroundImage;

  /// (Added by Pleroma)
  @JsonKey(name: 'background_upload_limit')
  final int? backgroundUploadLimit;

  /// (Added by Pleroma)
  @JsonKey(name: 'banner_upload_limit')
  final int? bannerUploadLimit;

  /// Admin-defined description of the Mastodon site.
  final String description;

  /// A shorter description defined by the admin.
  final String? shortDescription;

  /// An email that may be contacted for any inquiries.
  final String email;

  /// Primary langauges of the website and its staff.
  final Iterable<String> languages;

  /// (Added by Pleroma)
  @JsonKey(name: 'max_toot_chars')
  final int? maxTootChars;

  @JsonKey(name: 'poll_limits')
  final dynamic pollLimits;

  /// Whether registrations are enabled.
  final bool registrations;

  final String? thumbnail;

  /// The title of the website.
  final String title;

  /// (Added by Pleroma)
  @JsonKey(name: 'upload_limit')
  final int? uploadLimit;

  /// The domain name of the instance.
  final String uri;

  /// URLs of interest for clients apps.
  final MastodonInstanceUrls urls;

  /// The version of Mastodon installed on the instance.
  final String version;

  /// Statistics about how much information the instance contains.
  final MastodonInstanceStatistics stats;

  /// A user that can be contacted, as an alternative to [email].
  @JsonKey(name: 'contact_account')
  final MastodonAccount? contactAccount;

  /// Whether invites are enabled.
  @JsonKey(name: 'invites_enabled')
  final bool? invitesEnabled;

  /// Whether registrations require moderator approval.
  @JsonKey(name: 'approval_required')
  final bool approvalRequired;

  const MastodonInstance({
    required this.uri,
    required this.title,
    required this.description,
    required this.email,
    required this.version,
    required this.languages,
    required this.registrations,
    required this.approvalRequired,
    required this.urls,
    required this.stats,
    this.shortDescription,
    this.invitesEnabled,

    // optional attributes
    this.thumbnail,
    this.contactAccount,

    // pleroma attributes
    this.avatarUploadLimit,
    this.backgroundImage,
    this.backgroundUploadLimit,
    this.bannerUploadLimit,
    this.maxTootChars,
    this.pollLimits,
    this.uploadLimit,
  });

  factory MastodonInstance.fromJson(Map<String, dynamic> json) =>
      _$MastodonInstanceFromJson(json);

  Map<String, dynamic> toJson() => _$MastodonInstanceToJson(this);
}
