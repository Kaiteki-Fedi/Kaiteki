class Embed<T> {
  final T? source;
  final String? title;
  final String? description;
  final Uri? imageUrl;
  final Uri uri;
  final String? siteName;

  const Embed({
    this.source,
    required this.uri,
    this.title,
    this.description,
    this.imageUrl,
    this.siteName,
  });
}
