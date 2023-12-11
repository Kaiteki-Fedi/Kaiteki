import 'avatar_decoration.dart';
import 'emoji.dart';
import 'user_flags.dart';
import 'user_handle.dart';

/// A class representing an user or account.
class User<T> {
  final T? source;

  /// The time that this user was created.
  final DateTime? joinDate;

  final String username;

  /// The display name
  final String? displayName;

  /// The URL of the user's avatar.
  final Uri? avatarUrl;

  /// The blur hash of the user's banner.
  final String? avatarBlurHash;

  /// The URL of the user's banner.
  final Uri? bannerUrl;

  /// The blur hash of the user's banner.
  final String? bannerBlurHash;

  /// The decorations on the user's avatar.
  final List<AvatarDecoration> avatarDecorations;

  /// The ID of the user.
  final String id;

  /// The emojis used to display this user.
  final List<Emoji>? emojis;

  final String? description;

  /// The instance the user is on.
  final String host;

  final UserDetails details;

  /// External URL to the profile of this [User].
  final Uri? url;

  final UserFlags? flags;

  final UserMetrics metrics;

  final UserState state;

  final UserType type;

  const User({
    required this.displayName,
    required this.host,
    required this.id,
    required this.username,
    this.source,
    this.avatarBlurHash,
    this.avatarUrl,
    this.bannerBlurHash,
    this.bannerUrl,
    this.description,
    this.details = const UserDetails(),
    this.emojis,
    this.flags,
    this.metrics = const UserMetrics(),
    this.joinDate,
    this.url,
    this.state = const UserState(),
    this.type = UserType.person,
    this.avatarDecorations = const [],
  });

  UserHandle get handle => UserHandle.fromUser(this);

  /// Checks whether the user has a display name and it is not empty.
  bool get hasDisplayName => displayName != null && displayName!.isNotEmpty;

  User copyWith({
    T? source,
    DateTime? joinDate,
    String? username,
    String? displayName,
    Uri? avatarUrl,
    String? avatarBlurHash,
    Uri? bannerUrl,
    String? bannerBlurHash,
    String? id,
    List<Emoji>? emojis,
    String? description,
    String? host,
    UserDetails? details,
    Uri? url,
    UserFlags? flags,
    UserMetrics? metrics,
    UserState? state,
  }) {
    return User(
      displayName: displayName ?? this.displayName,
      host: host ?? this.host,
      id: id ?? this.id,
      username: username ?? this.username,
      source: source ?? this.source,
      avatarBlurHash: avatarBlurHash ?? this.avatarBlurHash,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bannerBlurHash: bannerBlurHash ?? this.bannerBlurHash,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      description: description ?? this.description,
      details: details ?? this.details,
      emojis: emojis ?? this.emojis,
      flags: flags ?? this.flags,
      metrics: metrics ?? this.metrics,
      joinDate: joinDate ?? this.joinDate,
      url: url ?? this.url,
      state: state ?? this.state,
    );
  }
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
  final List<MapEntry<String, String>>? fields;

  const UserDetails({this.birthday, this.website, this.location, this.fields});
}

/// The follow state of an [User].
enum UserFollowState {
  /// The user is not being followed.
  notFollowing,

  /// A follow request is pending.
  pending,

  /// The user is being followed.
  following,
}

/// Metrics of an [User].
class UserMetrics {
  /// The amount of posts the user has made.
  final int? postCount;

  /// The amount of followers the user has.
  final int? followerCount;

  /// The amount of users the user follows.
  final int? followingCount;

  const UserMetrics({
    this.postCount,
    this.followerCount,
    this.followingCount,
  });
}

/// The state of an [User].
class UserState {
  /// Whether the user is blocked.
  final bool? isBlocked;

  /// Whether the user is muted.
  final bool? isMuted;

  /// The follow state of the user.
  final UserFollowState? follow;

  const UserState({
    this.isBlocked,
    this.isMuted,
    this.follow,
  });

  UserState copyWith({
    bool? isBlocked,
    bool? isMuted,
    UserFollowState? follow,
  }) {
    return UserState(
      isBlocked: isBlocked ?? this.isBlocked,
      isMuted: isMuted ?? this.isMuted,
      follow: follow ?? this.follow,
    );
  }
}

enum UserType { person, bot, group, organization }
