class GenerateSessionResponse {
  late final String token;
  late final String url;

  GenerateSessionResponse.fromJson(Map<String, dynamic> json) {
    token = json["token"];
    url = json["url"];
  }
}
