class SignInResponse {
  late final String id;
  late final String i;

  SignInResponse.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    i = json["i"];
  }
}
