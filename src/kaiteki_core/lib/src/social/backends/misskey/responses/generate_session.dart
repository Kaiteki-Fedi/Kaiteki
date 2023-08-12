import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';

part 'generate_session.g.dart';

@JsonSerializable()
class GenerateSessionResponse {
  final String token;
  final String url;

  const GenerateSessionResponse(this.token, this.url);

  factory GenerateSessionResponse.fromJson(JsonMap json) =>
      _$GenerateSessionResponseFromJson(json);

  JsonMap toJson() => _$GenerateSessionResponseToJson(this);
}
