import "package:kaiteki_core/model.dart";

sealed class Media {
  final MediaType type;

  /// The original filename, if available.
  final String? fileName;

  /// Description of the media.
  final String? description;

  const Media({
    this.type = MediaType.file,
    this.fileName,
    this.description,
  });
}

final class RemoteMedia extends Media {
  final Uri url;

  const RemoteMedia(
    this.url, {
    super.type = MediaType.file,
    super.fileName,
    super.description,
  });

  factory RemoteMedia.fromAttachment(Attachment attachment) {
    return RemoteMedia(
      attachment.url,
      type: switch (attachment.type) {
        AttachmentType.image => MediaType.image,
        AttachmentType.video => MediaType.video,
        AttachmentType.audio => MediaType.audio,
        AttachmentType.file => MediaType.file,
        AttachmentType.animated => MediaType.video,
      },
      fileName: attachment.fileName,
      description: attachment.description,
    );
  }
}

enum MediaType {
  /// Binary file not suitable for preview
  file,

  /// Image file
  image,

  /// Video file
  video,

  /// Audio file
  audio,

  /// Plain-text file
  text,
}
