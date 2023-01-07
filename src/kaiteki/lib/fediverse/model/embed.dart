class Embed {
  final String? title;
  final String? description;
  final String? largeImageUrl;
  final String? smallImageUrl;
  final Uri uri;

  const Embed({
    required this.uri,
    this.title,
    this.description,
    this.largeImageUrl,
    this.smallImageUrl,
  });
}
