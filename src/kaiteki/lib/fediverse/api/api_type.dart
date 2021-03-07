enum ApiType { Mastodon, Pleroma, Misskey }

extension ApiTypeExtension on ApiType {
  String toId() {
    switch (this) {
      case ApiType.Mastodon:
        return "mastodon";
      case ApiType.Pleroma:
        return "pleroma";
      case ApiType.Misskey:
        return "misskey";
      default:
        return this.toString();
    }
  }
}
