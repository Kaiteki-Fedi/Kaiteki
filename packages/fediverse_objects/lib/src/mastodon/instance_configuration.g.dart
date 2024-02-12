// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstanceConfiguration _$InstanceConfigurationFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'InstanceConfiguration',
      json,
      ($checkedConvert) {
        final val = InstanceConfiguration(
          accounts: $checkedConvert(
              'accounts',
              (v) => v == null
                  ? null
                  : InstanceConfigurationAccounts.fromJson(
                      v as Map<String, dynamic>)),
          statuses: $checkedConvert(
              'statuses',
              (v) => v == null
                  ? null
                  : InstanceConfigurationStatuses.fromJson(
                      v as Map<String, dynamic>)),
          polls: $checkedConvert(
              'polls',
              (v) => v == null
                  ? null
                  : InstanceConfigurationPolls.fromJson(
                      v as Map<String, dynamic>)),
          mediaAttachments: $checkedConvert(
              'media_attachments',
              (v) => InstanceConfigurationMediaAttachments.fromJson(
                  v as Map<String, dynamic>)),
          reactions: $checkedConvert(
              'reactions',
              (v) => v == null
                  ? null
                  : InstanceConfigurationReactions.fromJson(
                      v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {'mediaAttachments': 'media_attachments'},
    );

Map<String, dynamic> _$InstanceConfigurationToJson(
        InstanceConfiguration instance) =>
    <String, dynamic>{
      'reactions': instance.reactions,
      'accounts': instance.accounts,
      'statuses': instance.statuses,
      'polls': instance.polls,
      'media_attachments': instance.mediaAttachments,
    };
