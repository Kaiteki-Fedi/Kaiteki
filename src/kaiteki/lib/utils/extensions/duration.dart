extension DurationExtension on Duration {
  String toStringHuman() {
    if (inDays != 0) return "${inDays}d";
    if (inHours != 0) return "${inHours}h";
    if (inMinutes != 0) return "${inMinutes}m";
    return "${inSeconds}s";
  }
}
