class MisskeyCreateAppResponse {
  String id;
  String name;
  String callbackUrl;
  List<String> permission;
  String secret;

  MisskeyCreateAppResponse.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    callbackUrl = json["callbackUrl"];
    permission = json["permission"].cast<String>();
    secret = json["secret"];
  }
}