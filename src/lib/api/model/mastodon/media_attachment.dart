import 'package:json_annotation/json_annotation.dart';
part 'media_attachment.g.dart';

@JsonSerializable(createToJson: false)
class MastodonMediaAttachment {
  final String description;

  final String id;

  //final dynamic pleroma;

  @JsonKey(name: "preview_url")
  final String previewUrl;

  @JsonKey(name: "remote_url")
  final String remoteUrl;

  @JsonKey(name: "text_url")
  final String textUrl;

  final String type;

  final String url;

  const MastodonMediaAttachment({
    this.description,
    this.id,
    //this.pleroma,
    this.previewUrl,
    this.remoteUrl,
    this.textUrl,
    this.type,
    this.url,
  });

  factory MastodonMediaAttachment.fromJson(Map<String, dynamic> json) => _$MastodonMediaAttachmentFromJson(json);
}