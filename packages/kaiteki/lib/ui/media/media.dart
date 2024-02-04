import "package:cross_file/cross_file.dart";
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

final class LocalMedia extends Media {
  final XFile file;

  const LocalMedia(
    this.file, {
    super.type = MediaType.file,
    super.description,
  });

  @override
  String? get fileName => file.name;
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
      type: MediaType.fromAttachmentType(attachment.type),
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
  text;

  factory MediaType.fromAttachmentType(AttachmentType type) {
    return switch (type) {
      AttachmentType.image => MediaType.image,
      AttachmentType.video => MediaType.video,
      AttachmentType.audio => MediaType.audio,
      AttachmentType.file => MediaType.file,
      AttachmentType.animated => MediaType.video,
    };
  }

  factory MediaType.determineFromMimeType(String mimetype) {
    final [type, _] = mimetype.split("/");
    return switch (type) {
      "image" => MediaType.image,
      "video" => MediaType.video,
      "audio" => MediaType.audio,
      "text" => MediaType.text,
      _ => MediaType.file
    };
  }
}
