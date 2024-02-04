import 'package:fediverse_objects/misskey.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';

part 'userkey.g.dart';

@JsonSerializable()
class UserkeyResponse {
  final String accessToken;
  final User? user;

  const UserkeyResponse(this.accessToken, this.user);

  factory UserkeyResponse.fromJson(JsonMap json) =>
      _$UserkeyResponseFromJson(json);

  JsonMap toJson() => _$UserkeyResponseToJson(this);
}
