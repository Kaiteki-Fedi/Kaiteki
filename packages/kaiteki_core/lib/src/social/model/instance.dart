import 'ad.dart';
import 'user.dart';

class Instance<T> {
  final T? source;
  final String name;
  final Uri? iconUrl;
  final Uri? mascotUrl;
  final Uri? backgroundUrl;

  final String? description;

  /// How many posts were made on this instance;
  final int? postCount;

  /// How many users are registered on this instance;
  final int? userCount;

  final List<User>? administrators;
  final List<User>? moderators;

  final List<String>? rules;
  final Uri? tosUrl;

  /// A list of ads that are displayed on the instance.
  ///
  /// Null, if the instance does not support ads. Empty, if the instance
  /// supports ads, but does not have any ads.
  final List<Ad>? ads;

  const Instance({
    this.source,
    required this.name,
    this.iconUrl,
    this.backgroundUrl,
    this.mascotUrl,
    this.postCount,
    this.userCount,
    this.description,
    this.administrators,
    this.moderators,
    this.rules,
    this.tosUrl,
    this.ads,
  });
}
