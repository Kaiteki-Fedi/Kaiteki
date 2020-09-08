class MisskeySignInResponse {
  /// id of signed in user
  String id;

  /// user token
  String i;

  MisskeySignInResponse.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    i = json["i"];
  }
}