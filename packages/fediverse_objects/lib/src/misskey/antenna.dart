import 'package:json_annotation/json_annotation.dart';
part 'antenna.g.dart';

@JsonSerializable()
class Antenna {
  final String id;

  final DateTime createdAt;

  final String name;

  final List<List<String>> keywords;

  final List<List<String>> excludeKeywords;

  final AntennaSrc src;

  final String? userListId;

  final String? userGroupId;

  final List<String> users;

  final bool caseSensitive;

  final bool notify;

  final bool withReplies;

  final bool withFile;

  final bool hasUnreadNote;

  const Antenna({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.keywords,
    required this.excludeKeywords,
    required this.src,
    this.userListId,
    this.userGroupId,
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

enum AntennaSrc {
  home,
  all,
  users,
  list,
  group,
}
