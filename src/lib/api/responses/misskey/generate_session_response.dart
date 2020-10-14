class MisskeyGenerateSessionResponse {
  String token;
  String url;

  MisskeyGenerateSessionResponse.fromJson(Map<String, dynamic> json) {
    token = json["token"];
    url = json["url"];
  }
}
