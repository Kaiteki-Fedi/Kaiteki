import 'package:fediverse_objects/misskey.dart';

class MisskeyUserkeyResponse {
  late final String accessToken;
  late final User? user;

  MisskeyUserkeyResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json["accessToken"];

    if (json["user"] == null) {
      user = null;
    } else {
      user = User.fromJson(json["user"]);
    }
  }
}
