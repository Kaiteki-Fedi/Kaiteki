import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/api/model/misskey/user.dart';
part 'muting.g.dart';

@JsonSerializable()
class MisskeyMuting {
  final String id;

  final DateTime createdAt;

  final String muteeId;

  final MisskeyUser mutee;

  const MisskeyMuting({
    this.id,
    this.createdAt,
    this.muteeId,
    this.mutee,
  });

  factory MisskeyMuting.fromJson(Map<String, dynamic> json) => _$MisskeyMutingFromJson(json);
}