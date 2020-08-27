import 'package:kaiteki/api/model/mastodon/account.dart';
import 'package:kaiteki/api/model/mastodon/application.dart';
import 'package:kaiteki/api/model/mastodon/card.dart';
import 'package:kaiteki/api/model/mastodon/emoji.dart';
import 'package:kaiteki/api/model/mastodon/media_attachment.dart';
import 'package:kaiteki/api/model/pleroma/status.dart';

class MastodonStatus {
  MastodonAccount account;
  MastodonApplication application;
  bool bookmarked;
  MastodonCard card;
  String content;
//	dynamic createdAt;
  Iterable<MastodonEmoji> emojis;
  bool favourited;
  int favouritesCount;
  String id;
//	dynamic inReplyToAccountId;
//	dynamic inReplyToId;
//	dynamic language;
  Iterable<MastodonMediaAttachment> mediaAttachments;
//	List<dynamic> mentions;
  bool muted;
  bool pinned;
  PleromaStatus pleroma;
  // dynamic poll;
  MastodonStatus reblog;
  bool reblogged;
  int reblogsCount;
  int repliesCount;
  bool sensitive;
  String spoilerText;
//	List<dynamic> tags;
//	dynamic text;
  String uri;
  String url;
  String visibility;

  MastodonStatus.fromJson(Map<String, dynamic> json) {
    account = MastodonAccount.fromJson(json["account"]);
    application = MastodonApplication.fromJson(json["application"]);
    bookmarked = json["bookmarked"];

    if (json["card"] != null)
  		card = MastodonCard.fromJson(json["card"]);

    content = json["content"];
//		createdAt = json["created_at"];
//		emojis = json["emojis"];
    favourited = json["favourited"];
    favouritesCount = json["favourites_count"];
    id = json["id"];
//		inReplyToAccountId = json["in_reply_to_account_id"];
//		inReplyToId = json["in_reply_to_id"];
//		language = json["language"];
//		mentions = json["mentions"];
    muted = json["muted"];
    pinned = json["pinned"];

    if (json["pleroma"] != null)
      pleroma = PleromaStatus.fromJson(json["pleroma"]);
//		poll = json["poll"];
    reblogged = json["reblogged"];
    reblogsCount = json["reblogs_count"];
    repliesCount = json["replies_count"];
    sensitive = json["sensitive"];
    spoilerText = json["spoiler_text"];
//		tags = json["tags"];
//		text = json["text"];
    uri = json["uri"];
    url = json["url"];
    visibility = json["visibility"];

    if (json["media_attachments"] != null)
      mediaAttachments = json["media_attachments"].map<MastodonMediaAttachment>((j) => MastodonMediaAttachment.fromJson(j));

    if (json["emojis"] != null)
      emojis = json["emojis"].map<MastodonEmoji>((j) => MastodonEmoji.fromJson(j));

    if (json["reblog"] != null)
      reblog = MastodonStatus.fromJson(json["reblog"]);
  }

  MastodonStatus.example() {
    account = MastodonAccount.example();
    content = "Hello everyone!";
    application = MastodonApplication.example();

    favourited = true;
    reblogged = true;
  }
}