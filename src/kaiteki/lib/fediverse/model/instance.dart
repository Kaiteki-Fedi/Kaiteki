class Instance<T> {
  /// The original object
  final T? source;
  final String name;
  final String? iconUrl;
  final String? mascotUrl;
  final String? backgroundUrl;

  Instance({
    required this.name,
    this.iconUrl,
    required this.source,
    this.backgroundUrl,
    this.mascotUrl,
  });
}
