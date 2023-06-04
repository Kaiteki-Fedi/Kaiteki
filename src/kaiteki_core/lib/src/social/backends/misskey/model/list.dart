import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';

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

  factory MisskeyList.fromJson(JsonMap json) => _$MisskeyListFromJson(json);

  JsonMap toJson() => _$MisskeyListToJson(this);
}
