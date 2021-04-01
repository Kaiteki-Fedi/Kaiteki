class MisskeyGenerateSessionResponse {
  late final String token;
  late final String url;

  MisskeyGenerateSessionResponse.fromJson(Map<String, dynamic> json) {
    token = json["token"];
    url = json["url"];
  }
}
