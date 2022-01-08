import 'package:kaiteki/constants.dart';
import 'package:kaiteki/fediverse/model/emoji.dart';

/// A class representing an user or account.
class User<T> {
  /// The original object.
  final T? source;

  /// The time that this user was created.
  final DateTime? joinDate;

  /// The user's birthday, if known.
  final DateTime? birthday;

  final String username;

  /// The display name
  final String displayName;

  /// The URL of the user's avatar. Null, if the user didn't set one.
  final String? avatarUrl;

  /// The URL of the user's banner. Null, if the user didn't set one.
  final String? bannerUrl;

  /// The id of the user.
  final String id;

  /// The emojis used to display this user.
  final Iterable<Emoji>? emojis;

  final String? description;

  final int? postCount;
  final int? followerCount;
  final int? followingCount;

  /// The instance the user is on, [null] if it's the current local instance.
  final String? host;

  /// The location defined by the user.
  final String? location;

  final Map<String, String>? fields;

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
    this.birthday,
    this.emojis,
    this.postCount,
    this.followerCount,
    this.followingCount,
    this.fields,
  });

  factory User.example() {
    return User(
      username: "NyaNya",
      displayName: "banned for being a cute neko",
      avatarUrl: Constants.exampleAvatar,
      joinDate: DateTime.now(),
      id: "CuteNeko-Account",
      source: null,
      host: 'cute.social',
    );
  }
}
