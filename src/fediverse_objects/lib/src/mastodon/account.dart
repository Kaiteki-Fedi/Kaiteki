import 'package:fediverse_objects/src/mastodon/emoji.dart';
import 'package:fediverse_objects/src/mastodon/field.dart';
import 'package:fediverse_objects/src/mastodon/source.dart';
import 'package:fediverse_objects/src/pleroma/account.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

/// Represents a user of Mastodon and their associated profile.
@JsonSerializable()
class MastodonAccount {
  /// The Webfinger account URI.
  ///
  /// Equal to `username` for local users, or `username@domain` for remote users.
  final String acct;

  /// An image icon that is shown next to statuses and in the profile. (URL)
  final String avatar;

  /// A static version of the avatar.
  ///
  /// Equal to `avatar` if its value is a static image; different if `avatar` is an animated GIF.
  @JsonKey(name: 'avatar_static')
  final String avatarStatic;

  /// A presentational flag.
  ///
  /// Indicates that the account may perform automated actions, may not be monitored, or identifies as a robot.
  final bool? bot;

  /// When the account was created.
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// The profile's display name.
  @JsonKey(name: 'display_name')
  final String displayName;

  /// Custom emoji entities to be used when rendering the profile.
  ///
  /// If none, an empty array will be returned.
  final Iterable<MastodonEmoji> emojis;

  /// Additional metadata attached to a profile as name-value pairs.
  final Iterable<MastodonField>? fields;

  /// The reported followers of this profile.
  @JsonKey(name: 'followers_count')
  final int followersCount;

  /// The reported follows of this profile.
  @JsonKey(name: 'following_count')
  final int followingCount;

  /// An image banner that is shown above the profile and in profile cards.
  final String header;

  /// A static version of the header.
  ///
  /// Equal to `header` if its value is a static image; different if `header` is an animated GIF.
  @JsonKey(name: 'header_static')
  final String headerStatic;

  /// The account id.
  final String id;

  /// Whether the account manually approves follow requests.
  final bool locked;

  /// The profile's bio / description. (Encoded in HTML)
  final String note;

  /// Pleroma's extensions to [MastodonAccount].
  final PleromaAccount? pleroma;

  /// An extra entity to be used with API methods to [verify credentials](https://docs.joinmastodon.org/methods/accounts/#verify-account-credentials) and [update credentials](https://docs.joinmastodon.org/methods/accounts/#update-account-credentials).
  final MastodonSource? source;

  /// How many statuses are attached to this account.
  @JsonKey(name: 'statuses_count')
  final int statusesCount;

  /// The location of the user's profile page.
  final String url;

  /// The username of the account, not including domain.
  final String username;

  /// Whether the account has opted into discovery features such as the profile directory. (Nullable because of Pleroma support)
  final bool? discoverable;

  /// When the most recent status was posted. (Nullable because of Pleroma)
  @JsonKey(name: 'last_status_at')
  final DateTime? lastStatusAt;

  /// Indicates that the profile is currently inactive and that its user has moved to a new account.
  final bool? moved;

  /// An extra entity returned when an account is suspended.
  final bool? suspended;

  /// When a timed mute will expire, if applicable.
  final DateTime? muteExpiredAt;

  const MastodonAccount({
    required this.id,
    required this.username,
    required this.url,
    required this.acct,

    // display attributes
    required this.displayName,
    required this.note,
    required this.avatar,
    required this.avatarStatic,
    required this.header,
    required this.headerStatic,
    required this.locked,
    required this.emojis,
    this.discoverable,

    // statistical attributes
    required this.createdAt,
    this.lastStatusAt,
    required this.statusesCount,
    required this.followersCount,
    required this.followingCount,

    // optional
    this.moved,
    this.fields,
    this.bot,
    this.source,
    this.pleroma,
    this.suspended,
    this.muteExpiredAt,
  });

  factory MastodonAccount.fromJson(Map<String, dynamic> json) =>
      _$MastodonAccountFromJson(json);

  Map<String, dynamic> toJson() => _$MastodonAccountToJson(this);
}
