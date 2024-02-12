// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance_configuration_statuses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstanceConfigurationStatuses _$InstanceConfigurationStatusesFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'InstanceConfigurationStatuses',
      json,
      ($checkedConvert) {
        final val = InstanceConfigurationStatuses(
          maxCharacters: $checkedConvert('max_characters', (v) => v as int),
          maxMediaAttachments:
              $checkedConvert('max_media_attachments', (v) => v as int?),
          charactersReservedPerUrl:
              $checkedConvert('characters_reserved_per_url', (v) => v as int?),
        );
        return val;
      },
      fieldKeyMap: const {
        'maxCharacters': 'max_characters',
        'maxMediaAttachments': 'max_media_attachments',
        'charactersReservedPerUrl': 'characters_reserved_per_url'
      },
    );

Map<String, dynamic> _$InstanceConfigurationStatusesToJson(
        InstanceConfigurationStatuses instance) =>
    <String, dynamic>{
      'max_characters': instance.maxCharacters,
      'max_media_attachments': instance.maxMediaAttachments,
      'characters_reserved_per_url': instance.charactersReservedPerUrl,
    };
