class PleromaNotification {
  bool isMuted;
  bool isSeen;

  PleromaNotification.fromJson(Map<String, dynamic> json) {
    isMuted = json["isMuted"];
    isSeen = json["isSeen"];
  }
}