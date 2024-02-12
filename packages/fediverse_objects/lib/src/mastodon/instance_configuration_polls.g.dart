// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance_configuration_polls.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstanceConfigurationPolls _$InstanceConfigurationPollsFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'InstanceConfigurationPolls',
      json,
      ($checkedConvert) {
        final val = InstanceConfigurationPolls(
          $checkedConvert('max_options', (v) => v as int),
          $checkedConvert('max_characters_per_option', (v) => v as int),
          $checkedConvert('min_expiration', (v) => v as int),
          $checkedConvert('max_expiration', (v) => v as int),
        );
        return val;
      },
      fieldKeyMap: const {
        'maxOptions': 'max_options',
        'maxCharactersPerOption': 'max_characters_per_option',
        'minExpiration': 'min_expiration',
        'maxExpiration': 'max_expiration'
      },
    );

Map<String, dynamic> _$InstanceConfigurationPollsToJson(
        InstanceConfigurationPolls instance) =>
    <String, dynamic>{
      'max_options': instance.maxOptions,
      'max_characters_per_option': instance.maxCharactersPerOption,
      'min_expiration': instance.minExpiration,
      'max_expiration': instance.maxExpiration,
    };
