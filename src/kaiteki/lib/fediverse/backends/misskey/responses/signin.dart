class MisskeySignInResponse {
  /// id of signed in user
  late final String id;

  /// user token
  late final String i;

  MisskeySignInResponse.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    i = json["i"];
  }
}
