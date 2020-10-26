import 'package:json_annotation/json_annotation.dart';
part 'sign_in.g.dart';

@JsonSerializable(createFactory: false)
class MisskeySignInRequest {
  final String username;

  final String password;

  final String token;

  const MisskeySignInRequest({
    this.username,
    this.password,
    this.token,
  });

  Map<String, dynamic> toJson() => _$MisskeySignInRequestToJson(this);
}