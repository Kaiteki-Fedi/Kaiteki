import 'package:kaiteki_core/src/social/model/adapted_entity.dart';

class PostList<T> extends AdaptedEntity<T> {
  final String name;
  final String id;
  final DateTime? createdAt;

  const PostList({
    super.source,
    required this.name,
    required this.id,
    this.createdAt,
  });
}
