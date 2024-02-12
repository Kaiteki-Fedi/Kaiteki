// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance_configuration_reactions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstanceConfigurationReactions _$InstanceConfigurationReactionsFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'InstanceConfigurationReactions',
      json,
      ($checkedConvert) {
        final val = InstanceConfigurationReactions(
          maxReactions: $checkedConvert('max_reactions', (v) => v as int),
        );
        return val;
      },
      fieldKeyMap: const {'maxReactions': 'max_reactions'},
    );

Map<String, dynamic> _$InstanceConfigurationReactionsToJson(
        InstanceConfigurationReactions instance) =>
    <String, dynamic>{
      'max_reactions': instance.maxReactions,
    };
