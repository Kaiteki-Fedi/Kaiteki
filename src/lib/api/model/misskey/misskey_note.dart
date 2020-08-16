import 'package:kaiteki/api/model/misskey/misskey_emoji.dart';

class MisskeyNote {
  String id;
//dynamic createdAt;
  String userId;
//dynamic user;
  String text;
//dynamic cw;
  String visibility;
  int renoteCount;
  int repliesCount;
//dynamic reactions;
  List<MisskeyEmoji> emojis;
  //List<FileId> fileIds;
  //List<File> files;
  String replyId;
//dynamic renoteId;
  List<String> mentions;
  String uri;
//dynamic reply;

  MisskeyNote.fromJson(Map<String, dynamic> json) {
    id = json["id"];
//	createdAt = json["createdAt"];
    userId = json["userId"];
//	user = json["user"];
    text = json["text"];
//	cw = json["cw"];
    visibility = json["visibility"];
    renoteCount = json["renoteCount"];
    repliesCount = json["repliesCount"];
//	reactions = json["reactions"];
    emojis = json["emojis"].map((j) => MisskeyEmoji.fromJson(j));
    //fileIds = json["fileIds"];
    //files = json["files"];
    replyId = json["replyId"];
//	renoteId = json["renoteId"];
    mentions = json["mentions"].cast<String>();
    uri = json["uri"];
//	reply = json["reply"];
  }
}