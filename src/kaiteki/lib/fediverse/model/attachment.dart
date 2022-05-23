class Attachment<T> {
  final T source;

  final String previewUrl;
  final String url;
  final String? description;
  final AttachmentType type;
  final bool isSensitive;

  Attachment({
    required this.source,
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
