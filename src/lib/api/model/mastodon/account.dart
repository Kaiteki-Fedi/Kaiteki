import 'package:kaiteki/api/model/mastodon/account_field.dart';
import 'package:kaiteki/api/model/mastodon/emoji.dart';
import 'package:kaiteki/api/model/pleroma/account.dart';

class MastodonAccount {
	String acct;
	String avatar;
	String avatarStatic;
	bool bot;
//	dynamic createdAt;
	String displayName;
	Iterable<MastodonEmoji> emojis;
	Iterable<MastodonAccountField> fields;
	int followersCount;
	int followingCount;
	String header;
	String headerStatic;
	String id;
	bool locked;
	String note;
	PleromaAccount pleroma;
//	dynamic source;
	int statusesCount;
	String url;
	String username;

	MastodonAccount.fromJson(Map<String, dynamic> json) {
		acct = json["acct"];
		avatar = json["avatar"];
		avatarStatic = json["avatar_static"];
		bot = json["bot"];
		displayName = json["display_name"];
		followersCount = json["followers_count"];
		followingCount = json["following_count"];
		header = json["header"];
		headerStatic = json["header_static"];
		id = json["id"];
		locked = json["locked"];
		note = json["note"];

		if (json["pleroma"] != null)
			pleroma = PleromaAccount.fromJson(json["pleroma"]);

		if (json["media_attachments"] != null)
			fields = json["fields"].map<MastodonAccountField>((j) => MastodonAccountField.fromJson(j));

		if (json["emojis"] != null)
			emojis = json["emojis"].map<MastodonEmoji>((j) => MastodonEmoji.fromJson(j));

		statusesCount = json["statuses_count"];
		url = json["url"];
		username = json["username"];

		// source = json["source"];
		// emojis = json["emojis"];
		// createdAt = json["created_at"];
	}

	MastodonAccount.example() {
		username = "NyaNya";
		displayName = "banned for being a cute neko";
		avatar = "https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2F24.media.tumblr.com%2Ftumblr_me574zdKgg1rhcknwo1_1280.jpg&f=1&nofb=1";
	}
}
