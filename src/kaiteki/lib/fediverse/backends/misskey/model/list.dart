import 'package:json_annotation/json_annotation.dart';

part 'list.g.dart';

@JsonSerializable()
class MisskeyList {
  final String id;
  final DateTime createdAt;
  final String name;
  final List<String>? userIds;

  const MisskeyList({
    required this.id,
    required this.createdAt,
    required this.name,
    this.userIds,
  });

  factory MisskeyList.fromJson(Map<String, dynamic> json) =>
      _$MisskeyListFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyListToJson(this);
}
