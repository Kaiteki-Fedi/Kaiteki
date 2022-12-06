import 'package:kaiteki/fediverse/model/emoji/emoji.dart';
import 'package:kaiteki/fediverse/model/user_flags.dart';

/// A class representing an user or account.
class User<T> {
  /// The original object.
  final T? source;

  /// The time that this user was created.
  final DateTime? joinDate;

  final String username;

  /// The display name
  final String? displayName;

  /// The URL of the user's avatar. Null, if the user didn't set one.
  final String? avatarUrl;

  /// The URL of the user's banner. Null, if the user didn't set one.
  final String? bannerUrl;

  /// The id of the user.
  final String id;

  /// The emojis used to display this user.
  final Iterable<Emoji>? emojis;

  final String? description;

  bool get hasDisplayName => displayName != null && displayName!.isNotEmpty;

  final int? postCount;
  final int? followerCount;
  final int? followingCount;

  /// The instance the user is on.
  final String host;

  final UserDetails details;

  /// External URL to the profile of this [User].
  final String? url;

  final UserFlags? flags;

  const User({
    required this.id,
    required this.source,
    required this.username,
    required this.displayName,
    required this.host,
    this.joinDate,
    this.description,
    this.avatarUrl,
    this.bannerUrl,
    this.details = const UserDetails(),
    this.emojis,
    this.postCount,
    this.followerCount,
    this.followingCount,
    this.url,
    this.flags,
  });
}

/// Details set by the [User].
class UserDetails {
  /// The user's birthday, if known.
  final DateTime? birthday;

  /// The user's website, if known.
  final String? website;

  /// The location defined by the user.
  final String? location;

  /// The fields defined by the user.
  final Map<String, String>? fields;

  const UserDetails({this.birthday, this.website, this.location, this.fields});
}
