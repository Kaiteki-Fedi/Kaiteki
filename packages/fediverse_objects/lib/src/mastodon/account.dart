import 'package:json_annotation/json_annotation.dart';

import '../pleroma/account.dart';
import 'custom_emoji.dart';
import 'field.dart';
import 'source.dart';

part 'account.g.dart';

/// Represents a user of Mastodon and their associated profile.
@JsonSerializable(fieldRename: FieldRename.snake)
class Account {
  /// The Webfinger account URI.
  ///
  /// Equal to `username` for local users, or `username@domain` for remote users.
  final String acct;

  /// An image icon that is shown next to statuses and in the profile. (URL)
  final String avatar;

  /// A static version of the avatar.
  ///
  /// Equal to `avatar` if its value is a static image; different if `avatar` is an animated GIF.
  final String avatarStatic;

  /// A presentational flag.
  ///
  /// Indicates that the account may perform automated actions, may not be monitored, or identifies as a robot.
  final bool? bot;

  /// When the account was created.
  final DateTime createdAt;

  /// The profile's display name.
  final String displayName;

  /// Custom emoji entities to be used when rendering the profile.
  ///
  /// If none, an empty array will be returned.
  final List<CustomEmoji> emojis;

  /// Additional metadata attached to a profile as name-value pairs.
  final List<Field>? fields;

  /// The reported followers of this profile.
  final int followersCount;

  /// The reported follows of this profile.
  final int followingCount;

  /// An image banner that is shown above the profile and in profile cards.
  final String header;

  /// A static version of the header.
  ///
  /// Equal to `header` if its value is a static image; different if `header` is an animated GIF.
  final String headerStatic;

  /// The account id.
  final String id;

  /// Whether the account manually approves follow requests.
  final bool locked;

  /// The profile's bio / description. (Encoded in HTML)
  final String note;

  /// Pleroma's extensions to [Account].
  final PleromaAccount? pleroma;

  /// An extra entity to be used with API methods to [verify credentials](https://docs.joinmastodon.org/methods/accounts/#verify-account-credentials) and [update credentials](https://docs.joinmastodon.org/methods/accounts/#update-account-credentials).
  final Source? source;

  /// How many statuses are attached to this account.
  final int statusesCount;

  /// The location of the user's profile page.
  final String url;

  /// The username of the account, not including domain.
  final String username;

  /// Whether the account has opted into discovery features such as the profile directory.
  // NULL(pleroma)
  final bool? discoverable;

  /// When the most recent status was posted.
  // NULL(pleroma)
  final DateTime? lastStatusAt;

  /// Indicates that the profile is currently inactive and that its user has moved to a new account.
  final Account? moved;

  /// An extra entity returned when an account is suspended.
  final bool? suspended;

  /// When a timed mute will expire, if applicable.
  final DateTime? muteExpiredAt;

  /// Indicates that the account represents a Group actor.
  // NULL(pleroma)
  final bool? group;

  /// An extra attribute returned only when an account is silenced. If true, indicates that the account should be hidden behind a warning screen.
  final bool? limited;

  /// Whether the local user has opted out of being indexed by search engines.
  final bool? noindex;

  const Account({
    required this.acct,
    required this.avatar,
    required this.avatarStatic,
    required this.createdAt,
    required this.displayName,
    required this.emojis,
    required this.followersCount,
    required this.followingCount,
    required this.group,
    required this.header,
    required this.headerStatic,
    required this.id,
    required this.locked,
    required this.note,
    required this.statusesCount,
    required this.url,
    required this.username,
    this.bot,
    this.discoverable,
    this.fields,
    this.lastStatusAt,
    this.limited,
    this.moved,
    this.muteExpiredAt,
    this.noindex,
    this.pleroma,
    this.source,
    this.suspended,
  });

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
