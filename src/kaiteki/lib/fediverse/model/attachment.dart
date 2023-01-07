import 'package:kaiteki/fediverse/model/adapted_entity.dart';

class Attachment<T> extends AdaptedEntity<T> {
  final String previewUrl;
  final String url;
  final String? description;
  final AttachmentType type;
  final bool isSensitive;
  final String? blurHash;

  Attachment({
    super.source,
    required this.previewUrl,
    required this.url,
    this.description,
    this.type = AttachmentType.file,
    this.isSensitive = false,
    this.blurHash,
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
