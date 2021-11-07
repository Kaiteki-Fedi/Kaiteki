import 'package:json_annotation/json_annotation.dart';

part 'hashtag.g.dart';

@JsonSerializable()
class Hashtag {
  @JsonKey(name: 'tag')
  final String tag;

  @JsonKey(name: 'mentionedUsersCount')
  final int mentionedUsersCount;

  @JsonKey(name: 'mentionedLocalUsersCount')
  final int mentionedLocalUsersCount;

  @JsonKey(name: 'mentionedRemoteUsersCount')
  final int mentionedRemoteUsersCount;

  @JsonKey(name: 'attachedUsersCount')
  final int attachedUsersCount;

  @JsonKey(name: 'attachedLocalUsersCount')
  final int attachedLocalUsersCount;

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
