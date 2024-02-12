// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance_configuration_media_attachments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstanceConfigurationMediaAttachments
    _$InstanceConfigurationMediaAttachmentsFromJson(
            Map<String, dynamic> json) =>
        $checkedCreate(
          'InstanceConfigurationMediaAttachments',
          json,
          ($checkedConvert) {
            final val = InstanceConfigurationMediaAttachments(
              supportedMimeTypes: $checkedConvert(
                'supported_mime_types',
                (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
                readValue: InstanceConfigurationMediaAttachments
                    ._supportedMimeTypesReadValue,
              ),
              imageSizeLimit:
                  $checkedConvert('image_size_limit', (v) => v as int),
              imageMatrixLimit:
                  $checkedConvert('image_matrix_limit', (v) => v as int?),
              videoSizeLimit:
                  $checkedConvert('video_size_limit', (v) => v as int?),
              videoMatrixLimit:
                  $checkedConvert('video_matrix_limit', (v) => v as int?),
              videoFrameRateLimit:
                  $checkedConvert('video_frame_rate_limit', (v) => v as int?),
            );
            return val;
          },
          fieldKeyMap: const {
            'supportedMimeTypes': 'supported_mime_types',
            'imageSizeLimit': 'image_size_limit',
            'imageMatrixLimit': 'image_matrix_limit',
            'videoSizeLimit': 'video_size_limit',
            'videoMatrixLimit': 'video_matrix_limit',
            'videoFrameRateLimit': 'video_frame_rate_limit'
          },
        );

Map<String, dynamic> _$InstanceConfigurationMediaAttachmentsToJson(
        InstanceConfigurationMediaAttachments instance) =>
    <String, dynamic>{
      'supported_mime_types': instance.supportedMimeTypes,
      'image_size_limit': instance.imageSizeLimit,
      'image_matrix_limit': instance.imageMatrixLimit,
      'video_size_limit': instance.videoSizeLimit,
      'video_matrix_limit': instance.videoMatrixLimit,
      'video_frame_rate_limit': instance.videoFrameRateLimit,
    };
