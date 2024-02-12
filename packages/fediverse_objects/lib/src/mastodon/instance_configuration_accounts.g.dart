// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance_configuration_accounts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstanceConfigurationAccounts _$InstanceConfigurationAccountsFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'InstanceConfigurationAccounts',
      json,
      ($checkedConvert) {
        final val = InstanceConfigurationAccounts(
          maxFeaturedTags:
              $checkedConvert('max_featured_tags', (v) => v as int),
        );
        return val;
      },
      fieldKeyMap: const {'maxFeaturedTags': 'max_featured_tags'},
    );

Map<String, dynamic> _$InstanceConfigurationAccountsToJson(
        InstanceConfigurationAccounts instance) =>
    <String, dynamic>{
      'max_featured_tags': instance.maxFeaturedTags,
    };
