import 'package:kaiteki/api/model/mastodon/account_field.dart';
import 'package:kaiteki/api/model/mastodon/emoji.dart';
import 'package:kaiteki/api/model/pleroma/account.dart';
import 'package:json_annotation/json_annotation.dart';
part 'account.g.dart';

@JsonSerializable()
class MastodonAccount {
	final String acct;

	final String avatar;

	@JsonKey(name: "avatar_static")
	final String avatarStatic;

	final bool bot;

	@JsonKey(name: "created_at")
	final DateTime createdAt;

	@JsonKey(name: "display_name")
	final String displayName;

	final Iterable<MastodonEmoji> emojis;

	final Iterable<MastodonAccountField> fields;

	@JsonKey(name: "followers_count")
	final int followersCount;

	@JsonKey(name: "following_count")
	final int followingCount;

	final String header;

	@JsonKey(name: "header_static")
	final String headerStatic;

	final String id;

	final bool locked;

	final String note;

	final PleromaAccount pleroma;

	//final dynamic source;

	@JsonKey(name: "statuses_count")
	final int statusesCount;

	final String url;

	final String username;

	const MastodonAccount({
		this.acct,
		this.avatar,
		this.avatarStatic,
		this.bot,
		this.createdAt,
		this.displayName,
		this.emojis,
		this.fields,
		this.followersCount,
		this.followingCount,
		this.header,
		this.headerStatic,
		this.id,
		this.locked,
		this.note,
		this.pleroma,
		//this.source,
		this.statusesCount,
		this.url,
		this.username,
	});

	factory MastodonAccount.fromJson(Map<String, dynamic> json) => _$MastodonAccountFromJson(json);
}