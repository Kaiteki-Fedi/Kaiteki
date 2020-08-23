import 'package:kaiteki/api/model/mastodon/account.dart';

class MastodonInstance {
  String uri;
  String title;
  String shortDescription;
  String description;
  String email;
  String version;
//	dynamic urls;
//	dynamic stats;
  String thumbnail;
//	List<String> languages;
  bool registrations;
  bool approvalRequired;
  bool invitesEnabled;
  MastodonAccount contactAccount;

  MastodonInstance.fromJson(Map<String, dynamic> json) {
    uri = json["uri"];
    title = json["title"];
    shortDescription = json["short_description"];
    description = json["description"];
    email = json["email"];
    version = json["version"];
//		urls = json["urls"];
//		stats = json["stats"];
    thumbnail = json["thumbnail"];
//		languages = json["languages"];
    registrations = json["registrations"];
    approvalRequired = json["approval_required"];
    invitesEnabled = json["invites_enabled"];
    contactAccount = MastodonAccount.fromJson(json["contact_account"]);
  }
}
