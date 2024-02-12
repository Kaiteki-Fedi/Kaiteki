import 'package:json_annotation/json_annotation.dart';

part 'instance_configuration_media_attachments.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class InstanceConfigurationMediaAttachments {
  @JsonKey(readValue: _supportedMimeTypesReadValue)
  final List<String>? supportedMimeTypes;
  final int imageSizeLimit;
  final int? imageMatrixLimit;
  // NULL(friendica)
  final int? videoSizeLimit;
  final int? videoMatrixLimit;
  final int? videoFrameRateLimit;

  factory InstanceConfigurationMediaAttachments.fromJson(
          Map<String, dynamic> json) =>
      _$InstanceConfigurationMediaAttachmentsFromJson(json);

  InstanceConfigurationMediaAttachments({
    this.supportedMimeTypes,
    required this.imageSizeLimit,
    this.imageMatrixLimit,
    required this.videoSizeLimit,
    this.videoMatrixLimit,
    this.videoFrameRateLimit,
  });

  Map<String, dynamic> toJson() =>
      _$InstanceConfigurationMediaAttachmentsToJson(this);

  static Object? _supportedMimeTypesReadValue(Map map, String key) {
    final value = map[key];

    // HACK: Friendica Mastodon API implementation quirk
    if (value is Map<String, dynamic>) return value.keys.toList();

    return value;
  }
}
