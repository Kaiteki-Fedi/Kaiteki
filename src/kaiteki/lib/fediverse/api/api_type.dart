enum ApiType { mastodon, pleroma, misskey }

extension ApiTypeExtension on ApiType {
  String toId() {
    switch (this) {
      case ApiType.mastodon:
        return "mastodon";
      case ApiType.pleroma:
        return "pleroma";
      case ApiType.misskey:
        return "misskey";
      default:
        return toString();
    }
  }
}
