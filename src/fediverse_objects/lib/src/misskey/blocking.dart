import 'package:fediverse_objects/src/misskey/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blocking.g.dart';

@JsonSerializable()
class Blocking {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'blockeeId')
  final String blockeeId;

  @JsonKey(name: 'blockee')
  final User blockee;

  const Blocking({
    required this.id,
    required this.createdAt,
    required this.blockeeId,
    required this.blockee,
  });

  factory Blocking.fromJson(Map<String, dynamic> json) =>
      _$BlockingFromJson(json);

  Map<String, dynamic> toJson() => _$BlockingToJson(this);
}
