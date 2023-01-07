import 'package:kaiteki/fediverse/model/adapted_entity.dart';

class Instance<T> extends AdaptedEntity<T> {
  final String name;
  final String? iconUrl;
  final String? mascotUrl;
  final String? backgroundUrl;

  const Instance({
    super.source,
    required this.name,
    this.iconUrl,
    this.backgroundUrl,
    this.mascotUrl,
  });
}
