class Attachment<T> {
  final T? source;
  final Uri? previewUrl;
  final Uri url;
  final String? fileName;
  final Uri? externalUrl;
  final String? description;
  final AttachmentType type;
  final bool? isSensitive;
  final String? blurHash;

  const Attachment({
    this.source,
    required this.previewUrl,
    required this.url,
    this.description,
    this.type = AttachmentType.file,
    this.isSensitive,
    this.blurHash,
    this.externalUrl,
    this.fileName,
  });

  Attachment copyWith({
    Uri? previewUrl,
    Uri? url,
    String? description,
    AttachmentType? type,
    bool? isSensitive,
    String? blurHash,
  }) {
    return Attachment(
      source: source,
      previewUrl: previewUrl ?? this.previewUrl,
      url: url ?? this.url,
      description: description ?? this.description,
      type: type ?? this.type,
      isSensitive: isSensitive ?? this.isSensitive,
      blurHash: blurHash ?? this.blurHash,
    );
  }
}

enum AttachmentType {
  file, // default
  image,
  video,
  audio,

  /// GIFs, other animatable-s, but that shouldn't contain any audio
  animated,
}
