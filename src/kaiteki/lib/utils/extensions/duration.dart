extension DurationExtension on Duration {
  String toStringHuman() {
    if (inMinutes < 1) return "now";
    if (inDays != 0) return "${inDays}d";
    if (inHours != 0) return "${inHours}h";

    return "${inHours}m";
  }
}
