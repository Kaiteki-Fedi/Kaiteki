import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';

part 'signin.g.dart';

@JsonSerializable()
class SignInResponse {
  final String id;
  final String i;

  const SignInResponse(this.id, this.i);

  factory SignInResponse.fromJson(JsonMap json) =>
      _$SignInResponseFromJson(json);

  JsonMap toJson() => _$SignInResponseToJson(this);
}
