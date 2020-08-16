class PleromaEmojiReaction {
  int count;
  bool me;
  String name;

  PleromaEmojiReaction.fromJson(Map<String, dynamic> json) {
    count = json["count"];
    me = json["me"];
    name = json["name"];
  }
}