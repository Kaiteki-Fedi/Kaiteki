class PostList<T>  {
  final T? source;
  final String name;
  final String id;
  final DateTime? createdAt;

  const PostList({
    this.source,
    required this.name,
    required this.id,
    this.createdAt,
  });
}
