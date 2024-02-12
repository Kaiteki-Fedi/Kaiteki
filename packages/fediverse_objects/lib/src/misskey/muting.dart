import 'package:json_annotation/json_annotation.dart';

part 'muting.g.dart';

@JsonSerializable()
class Muting {
  final String id;

  final DateTime createdAt;

  final DateTime? expiresAt;

  final String muteeId;

  final dynamic mutee;

  const Muting({
    required this.id,
    required this.createdAt,
    this.expiresAt,
    required this.muteeId,
    required this.mutee,
  });

  factory Muting.fromJson(Map<String, dynamic> json) => _$MutingFromJson(json);
  Map<String, dynamic> toJson() => _$MutingToJson(this);
}
