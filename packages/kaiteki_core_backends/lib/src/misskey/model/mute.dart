import 'package:fediverse_objects/misskey.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';

part 'mute.g.dart';

@JsonSerializable()
class Mute {
  final String id;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String muteeId;
  final User mutee;

  const Mute({
    required this.id,
    required this.createdAt,
    required this.muteeId,
    required this.mutee,
    this.expiresAt,
  });

  factory Mute.fromJson(JsonMap json) => _$MuteFromJson(json);

  JsonMap toJson() => _$MuteToJson(this);
}
