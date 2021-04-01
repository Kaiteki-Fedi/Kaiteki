class PreviewCard {
  final String title;
  final String? description;
  final String? imageUrl;
  final String link;

  const PreviewCard({
    required this.title,
    required this.link,
    this.description,
    this.imageUrl,
  });
}
