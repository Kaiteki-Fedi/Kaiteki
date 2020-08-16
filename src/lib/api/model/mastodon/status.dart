import 'package:kaiteki/api/model/mastodon/account.dart';
import 'package:kaiteki/api/model/mastodon/application.dart';
import 'package:kaiteki/api/model/mastodon/emoji.dart';
import 'package:kaiteki/api/model/mastodon/media_attachment.dart';
import 'package:kaiteki/api/model/pleroma/pleroma_status.dart';

class Status {
  Account account;
  Application application;
  bool bookmarked;
//	dynamic card;
  String content;
//	dynamic createdAt;
  Iterable<Emoji> emojis;
  bool favourited;
  int favouritesCount;
  String id;
//	dynamic inReplyToAccountId;
//	dynamic inReplyToId;
//	dynamic language;
  Iterable<MediaAttachment> mediaAttachments;
//	List<dynamic> mentions;
  bool muted;
  bool pinned;
  PleromaStatus pleroma;
//	dynamic poll;
  Status reblog;
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

  Status.fromJson(Map<String, dynamic> json) {
    account = Account.fromJson(json["account"]);
    application = Application.fromJson(json["application"]);
    bookmarked = json["bookmarked"];
//		card = json["card"];
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
      mediaAttachments = json["media_attachments"].map<MediaAttachment>((j) => MediaAttachment.fromJson(j));

    if (json["emojis"] != null)
      emojis = json["emojis"].map<Emoji>((j) => Emoji.fromJson(j));

    if (json["reblog"] != null)
      reblog = Status.fromJson(json["reblog"]);
  }

  Status.example() {
    account = Account.example();
    content = "Hello everyone!";
    application = Application.example();

    favourited = true;
    reblogged = true;
  }
}