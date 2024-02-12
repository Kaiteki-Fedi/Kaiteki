import 'package:json_annotation/json_annotation.dart';

import 'trends_history.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag {
  /// The value of the hashtag after the # sign.
  final String name;

  /// A link to the hashtag on the instance.
  final Uri url;

  /// Usage statistics for given days (typically the past week).
  final List<TrendsHistory>? history;

  /// Whether the current token’s authorized user is following this tag.
  final bool? following;

  const Tag({
    required this.name,
    required this.url,
    this.history,
    this.following,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}
