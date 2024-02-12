import 'package:json_annotation/json_annotation.dart';

import 'account.dart';

part 'reaction.g.dart';

@JsonSerializable()
class Reaction {
  /// Array of accounts who have reacted with this emoji
  final List<Account>? accounts;

  /// The total number of users who have added this reaction.
  final int count;

  /// If there is a currently authorized user: Have you added this reaction?
  final bool me;

  /// The emoji used for the reaction. Either a unicode emoji, or a custom
  /// emoji’s shortcode.
  final String name;

  /// If the reaction is a custom emoji: A link to the custom emoji.
  final Uri? url;

  /// If the reaction is a custom emoji: A link to a non-animated version of the
  /// custom emoji.
  final Uri? staticUrl;

  const Reaction({
    required this.accounts,
    required this.count,
    required this.me,
    required this.name,
    this.url,
    this.staticUrl,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) =>
      _$ReactionFromJson(json);

  Map<String, dynamic> toJson() => _$ReactionToJson(this);
}
