import 'package:kaiteki/fediverse/model/adapted_entity.dart';

class Attachment<T> extends AdaptedEntity<T> {
  final String previewUrl;
  final String url;
  final String? description;
  final AttachmentType type;
  final bool isSensitive;

  Attachment({
    super.source,
    required this.previewUrl,
    required this.url,
    this.description,
    this.type = AttachmentType.file,
    this.isSensitive = false,
  });
}

enum AttachmentType {
  file, // default
  image,
  video,
  audio,

  /// GIFs, other animatable-s, but that shouldn't contain any audio
  animated,
}
