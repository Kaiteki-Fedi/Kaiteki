import 'package:fediverse_objects/misskey.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';

part 'check_session.g.dart';

@JsonSerializable()
class CheckSessionResponse {
  final String token;
  final User user;

  const CheckSessionResponse({
    required this.token,
    required this.user,
  });

  factory CheckSessionResponse.fromJson(JsonMap json) =>
      _$CheckSessionResponseFromJson(json);

  JsonMap toJson() => _$CheckSessionResponseToJson(this);
}
