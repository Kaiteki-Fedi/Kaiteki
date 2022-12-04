class Instance<T> {
  final T? source;
  final String name;
  final String? iconUrl;
  final String? mascotUrl;
  final String? backgroundUrl;

  const Instance({
    this.source,
    required this.name,
    this.iconUrl,
    this.backgroundUrl,
    this.mascotUrl,
  });
}
