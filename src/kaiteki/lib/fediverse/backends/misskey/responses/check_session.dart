import 'package:fediverse_objects/misskey.dart';
import 'package:json_annotation/json_annotation.dart';

part 'check_session.g.dart';

@JsonSerializable()
class MisskeyCheckSessionResponse {
  final String token;
  final User user;

  const MisskeyCheckSessionResponse({
    required this.token,
    required this.user,
  });

  factory MisskeyCheckSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$MisskeyCheckSessionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyCheckSessionResponseToJson(this);
}
