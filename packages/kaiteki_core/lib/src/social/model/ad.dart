class Ad {
  final Uri imageUrl;
  final Uri? linkUrl;
  final AdFormat? format;

  const Ad({required this.imageUrl, required this.linkUrl, this.format});
}

enum AdFormat { wide }
