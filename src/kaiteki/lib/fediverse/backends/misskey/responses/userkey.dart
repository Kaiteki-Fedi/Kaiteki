import 'package:fediverse_objects/misskey.dart';

class UserkeyResponse {
  final String accessToken;
  final User? user;

  UserkeyResponse(this.accessToken, this.user);

  factory UserkeyResponse.fromJson(Map<String, dynamic> json) {
    return UserkeyResponse(
      json["accessToken"],
      json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }
}
