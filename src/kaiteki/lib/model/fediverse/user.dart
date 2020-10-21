import 'package:flutter/foundation.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/model/fediverse/emoji.dart';

/// A class representing an user or account.
class User<T> {
  /// The original object.
  final T source;

  /// The time that this user was created.
  final DateTime joinDate;

  /// The user's birthday, if known.
  final DateTime birthday;

  final String username;

  /// The display name
  final String displayName;

  /// The URL of the user's avatar.
  final String avatarUrl;

  /// The URL of the user's banner.
  final String bannerUrl;

  /// The id of the user.
  final String id;

  /// The emojis used to display this user.
  final Iterable<Emoji> emojis;

  final String description;

  const User({
    @required this.id,
    @required this.source,
    @required this.joinDate,
    @required this.username,
    @required this.displayName,
    this.description,
    this.avatarUrl,
    this.bannerUrl,
    this.birthday,
    this.emojis,
  });

  factory User.example() {
    return User(
      username: "NyaNya",
      displayName: "banned for being a cute neko",
      avatarUrl: Constants.exampleAvatar,
      joinDate: DateTime.now(),
    );
  }
}