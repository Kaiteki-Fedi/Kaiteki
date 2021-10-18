import 'package:fediverse_objects/src/misskey/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'muting.g.dart';

@JsonSerializable()
class Muting {
  /// The unique identifier for this muting.
  @JsonKey(name: 'id')
  final String id;

  /// The date that the muting was created.
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'muteeId')
  final String muteeId;

  /// The mutee.
  @JsonKey(name: 'mutee')
  final User mutee;

  const Muting({
    required this.id,
    required this.createdAt,
    required this.muteeId,
    required this.mutee,
  });

  factory Muting.fromJson(Map<String, dynamic> json) => _$MutingFromJson(json);
  Map<String, dynamic> toJson() => _$MutingToJson(this);
}
