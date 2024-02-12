import 'package:json_annotation/json_annotation.dart';
part 'hashtag.g.dart';

@JsonSerializable()
class Hashtag {
  final String tag;

  final int mentionedUsersCount;

  final int mentionedLocalUsersCount;

  final int mentionedRemoteUsersCount;

  final int attachedUsersCount;

  final int attachedLocalUsersCount;

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
