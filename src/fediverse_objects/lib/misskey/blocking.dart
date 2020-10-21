import 'package:json_annotation/json_annotation.dart';

import 'package:fediverse_objects/misskey/user.dart';
part 'blocking.g.dart';

@JsonSerializable(createToJson: false)
class MisskeyBlocking {
  final String id;

  final DateTime createdAt;

  final String blockeeId;

  final MisskeyUser blockee;

  const MisskeyBlocking({
    this.id,
    this.createdAt,
    this.blockeeId,
    this.blockee,
  });

  factory MisskeyBlocking.fromJson(Map<String, dynamic> json) =>
      _$MisskeyBlockingFromJson(json);
}
