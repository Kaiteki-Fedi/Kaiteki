import 'package:json_annotation/json_annotation.dart';

part 'hashtag.g.dart';

@JsonSerializable()
class Hashtag {
  /// The hashtag name. No # prefixed.
  @JsonKey(name: 'tag')
  final String tag;

  /// Number of all users using this hashtag.
  @JsonKey(name: 'mentionedUsersCount')
  final int mentionedUsersCount;

  /// Number of local users using this hashtag.
  @JsonKey(name: 'mentionedLocalUsersCount')
  final int mentionedLocalUsersCount;

  /// Number of remote users using this hashtag.
  @JsonKey(name: 'mentionedRemoteUsersCount')
  final int mentionedRemoteUsersCount;

  /// Number of all users who attached this hashtag to profile.
  @JsonKey(name: 'attachedUsersCount')
  final int attachedUsersCount;

  /// Number of local users who attached this hashtag to profile.
  @JsonKey(name: 'attachedLocalUsersCount')
  final int attachedLocalUsersCount;

  /// Number of remote users who attached this hashtag to profile.
  @JsonKey(name: 'attachedRemoteUsersCount')
  final int attachedRemoteUsersCount;

  const Hashtag({
    required this.tag,
    required this.mentionedUsersCount,
    required this.mentionedLocalUsersCount,
    required this.mentionedRemoteUsersCount,
    required this.attachedUsersCount,
    required this.attachedLocalUsersCount,
    required this.attachedRemoteUsersCount,
  });

  factory Hashtag.fromJson(Map<String, dynamic> json) =>
      _$HashtagFromJson(json);
  Map<String, dynamic> toJson() => _$HashtagToJson(this);
}
