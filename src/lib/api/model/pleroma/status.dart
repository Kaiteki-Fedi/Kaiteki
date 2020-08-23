import 'package:kaiteki/api/model/pleroma/emoji_reaction.dart';

class PleromaStatus {
  //dynamic content;
  int conversationId;
  //dynamic directConversationId;
  List<PleromaEmojiReaction> emojiReactions;
  //dynamic expiresAt;
  //dynamic inReplyToAccountAcct;
  bool local;
  bool parentVisible;
  //dynamic spoilerText;
  bool threadMuted;

  PleromaStatus.fromJson(Map<String, dynamic> json) {
    //content = json["content"];
    conversationId = json["conversationId"];
    //directConversationId = json["directConversationId"];
    emojiReactions = json["emojiReactions"];
    //expiresAt = json["expiresAt"];
    //inReplyToAccountAcct = json["inReplyToAccountAcct"];
    local = json["local"];
    parentVisible = json["parentVisible"];
    //spoilerText = json["spoilerText"];
    threadMuted = json["threadMuted"];
  }
}