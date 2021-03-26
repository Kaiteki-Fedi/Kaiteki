import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/src/misskey/user.dart';
part 'muting.g.dart';

@JsonSerializable()
class MisskeyMuting {
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
  final MisskeyUser mutee;
  
  const MisskeyMuting({
    required this.id,
    required this.createdAt,
    required this.muteeId,
    required this.mutee,
  });

  factory MisskeyMuting.fromJson(Map<String, dynamic> json) => _$MisskeyMutingFromJson(json);
  Map<String, dynamic> toJson() => _$MisskeyMutingToJson(this);
}
