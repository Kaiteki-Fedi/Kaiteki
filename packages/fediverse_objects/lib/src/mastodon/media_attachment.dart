import 'package:json_annotation/json_annotation.dart';

part 'media_attachment.g.dart';

@Deprecated("Use MediaAttachment instead.")
typedef Attachment = MediaAttachment;

/// Represents a file or media attachment that can be added to a status.
@JsonSerializable(fieldRename: FieldRename.snake)
class MediaAttachment {
  /// Alternate text that describes what is in the media attachment, to be used for the visually impaired or when media attachments do not load.
  final String? description;

  /// The ID of the attachment in the database.
  final String id;

  // final dynamic pleroma;

  /// The location of a scaled-down preview of the attachment.
  final String? previewUrl;

  /// The location of the full-size original attachment on the remote website.
  ///
  /// Null if the attachment is local
  final String? remoteUrl;

  /// A shorter URL for the attachment.
  final String? textUrl;

  /// The type of the attachment.
  ///
  /// - `unknown` = unsupported or unrecognized file type
  /// - `image` = Static image
  /// - `gifv` = Looping, soundless animation
  /// - `video` = Video clip
  /// - `audio` = Audio track
  final String type;

  /// The location of the original full-size attachment.
  final String url;

  /// A hash computed by [the BlurHash algorithm](https://github.com/woltapp/blurhash), for generating colorful preview thumbnails when media has not been downloaded yet.
  final String? blurhash;

  const MediaAttachment({
    required this.id,
    required this.type,
    required this.url,
    required this.previewUrl,
    this.remoteUrl,
    this.textUrl,
    this.description,
    this.blurhash,
    // this.pleroma,
  });

  factory MediaAttachment.fromJson(Map<String, dynamic> json) =>
      _$MediaAttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$MediaAttachmentToJson(this);
}
