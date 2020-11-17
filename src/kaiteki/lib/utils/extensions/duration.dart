extension DurationExtension on Duration {
  String toStringHuman() {
    if (this.inMinutes < 1) return "now";
    if (this.inDays != 0) return "${this.inDays}d";
    if (this.inHours != 0) return "${this.inHours}h";

    return "${this.inHours}m";
  }
}
