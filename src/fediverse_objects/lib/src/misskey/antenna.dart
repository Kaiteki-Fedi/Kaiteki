import 'package:json_annotation/json_annotation.dart';

part 'antenna.g.dart';

@JsonSerializable()
class Antenna {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'keywords')
  final Iterable<Iterable<String>> keywords;

  @JsonKey(name: 'excludeKeywords')
  final Iterable<Iterable<String>> excludeKeywords;

  @JsonKey(name: 'src')
  final String src;

  @JsonKey(name: 'userListId')
  final String userListId;

  @JsonKey(name: 'userGroupId')
  final String userGroupId;

  @JsonKey(name: 'users')
  final Iterable<String> users;

  @JsonKey(name: 'caseSensitive')
  final bool caseSensitive;

  @JsonKey(name: 'notify')
  final bool notify;

  @JsonKey(name: 'withReplies')
  final bool withReplies;

  @JsonKey(name: 'withFile')
  final bool withFile;

  @JsonKey(name: 'hasUnreadNote')
  final bool hasUnreadNote;

  const Antenna({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.keywords,
    required this.excludeKeywords,
    required this.src,
    required this.userListId,
    required this.userGroupId,
    required this.users,
    required this.caseSensitive,
    required this.notify,
    required this.withReplies,
    required this.withFile,
    required this.hasUnreadNote,
  });

  factory Antenna.fromJson(Map<String, dynamic> json) =>
      _$AntennaFromJson(json);
  Map<String, dynamic> toJson() => _$AntennaToJson(this);
}
