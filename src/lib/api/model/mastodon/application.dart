import 'package:kaiteki/constants.dart';

class Application {
  String name;
  String website;

  String id;
  String clientId;
  String clientSecret;
  String vapidKey;
  String redirectUri;

  Application.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    website = json["website"];
    id = json["id"];
    clientId = json["client_id"];
    clientSecret = json["client_secret"];
    vapidKey = json["vapid_key"];
    redirectUri = json["redirect_uri"];
  }

  Application.example() {
    name = Constants.appName;
    website = Constants.appWebsite;
  }
}