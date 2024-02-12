// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaInstance _$PleromaInstanceFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PleromaInstance',
      json,
      ($checkedConvert) {
        final val = PleromaInstance(
          $checkedConvert('metadata',
              (v) => InstanceMetadata.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$PleromaInstanceToJson(PleromaInstance instance) =>
    <String, dynamic>{
      'metadata': instance.metadata,
    };

InstanceMetadata _$InstanceMetadataFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'InstanceMetadata',
      json,
      ($checkedConvert) {
        final val = InstanceMetadata(
          accountActivationRequired:
              $checkedConvert('account_activation_required', (v) => v as bool),
          features: $checkedConvert('features',
              (v) => (v as List<dynamic>).map((e) => e as String).toSet()),
          postFormats: $checkedConvert('post_formats',
              (v) => (v as List<dynamic>).map((e) => e as String).toSet()),
        );
        return val;
      },
      fieldKeyMap: const {
        'accountActivationRequired': 'account_activation_required',
        'postFormats': 'post_formats'
      },
    );

Map<String, dynamic> _$InstanceMetadataToJson(InstanceMetadata instance) =>
    <String, dynamic>{
      'account_activation_required': instance.accountActivationRequired,
      'features': instance.features.toList(),
      'post_formats': instance.postFormats.toList(),
    };
