import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/src/misskey/user.dart';
part 'blocking.g.dart';

@JsonSerializable()
class MisskeyBlocking {
  /// The unique identifier for this blocking.
  @JsonKey(name: 'id')
  final String id;
  
  /// The date that the blocking was created.
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  
  @JsonKey(name: 'blockeeId')
  final String blockeeId;
  
  /// The blockee.
  @JsonKey(name: 'blockee')
  final MisskeyUser blockee;
  
  const MisskeyBlocking({
    required this.id,
    required this.createdAt,
    required this.blockeeId,
    required this.blockee,
  });

  factory MisskeyBlocking.fromJson(Map<String, dynamic> json) => _$MisskeyBlockingFromJson(json);
  Map<String, dynamic> toJson() => _$MisskeyBlockingToJson(this);
}
