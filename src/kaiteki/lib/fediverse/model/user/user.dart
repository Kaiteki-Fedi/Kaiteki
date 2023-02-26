import "package:kaiteki/fediverse/model/adapted_entity.dart";
import "package:kaiteki/fediverse/model/emoji/emoji.dart";
import "package:kaiteki/fediverse/model/user/flags.dart";
import "package:kaiteki/fediverse/model/user/handle.dart";

/// A class representing an user or account.
class User<T> extends AdaptedEntity<T> {
  /// The time that this user was created.
  final DateTime? joinDate;

  final String username;

  /// The display name
  final String? displayName;

  /// The URL of the user's avatar. Null, if the user didn't set one.
  final Uri? avatarUrl;

  /// The blur hash of the user's banner.
  final String? avatarBlurHash;

  /// The URL of the user's banner. Null, if the user didn't set one.
  final String? bannerUrl;

  /// The blur hash of the user's banner.
  final String? bannerBlurHash;

  /// The id of the user.
  final String id;

  /// The emojis used to display this user.
  final List<Emoji>? emojis;

  final String? description;

  bool get hasDisplayName => displayName != null && displayName!.isNotEmpty;

  final int? postCount;
  final int? followerCount;
  final int? followingCount;

  /// The instance the user is on.
  final String host;

  final UserDetails details;

  /// External URL to the profile of this [User].
  final Uri? url;

  final UserFlags? flags;

  UserHandle get handle => UserHandle.fromUser(this);

  const User({
    required this.displayName,
    required this.host,
    required this.id,
    required this.username,
    super.source,
    this.avatarBlurHash,
    this.avatarUrl,
    this.bannerBlurHash,
    this.bannerUrl,
    this.description,
    this.details = const UserDetails(),
    this.emojis,
    this.flags,
    this.followerCount,
    this.followingCount,
    this.joinDate,
    this.postCount,
    this.url,
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
