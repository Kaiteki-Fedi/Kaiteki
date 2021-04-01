import 'package:json_annotation/json_annotation.dart';
part 'attachment.g.dart';

/// Represents a file or media attachment that can be added to a status.
@JsonSerializable()
class MastodonAttachment {
  /// Alternate text that describes what is in the media attachment, to be used for the visually impaired or when media attachments do not load.
  final String? description;

  /// The ID of the attachment in the database.
  final String id;

  // final dynamic pleroma;

  /// The location of a scaled-down preview of the attachment.
  @JsonKey(name: 'preview_url')
  final String previewUrl;

  /// The location of the full-size original attachment on the remote website.
  ///
  /// Null if the attachment is local
  @JsonKey(name: 'remote_url')
  final String? remoteUrl;

  /// A shorter URL for the attachment.
  @JsonKey(name: 'text_url')
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

  const MastodonAttachment({
    required this.id,
    required this.type,
    required this.url,
    required this.previewUrl,
    // optional attributes
    this.remoteUrl,
    this.textUrl,
    this.description,
    this.blurhash,
    // this.pleroma,
  });

  factory MastodonAttachment.fromJson(Map<String, dynamic> json) =>
      _$MastodonAttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$MastodonAttachmentToJson(this);
}
