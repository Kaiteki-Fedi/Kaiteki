// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frontend_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrontendConfiguration _$FrontendConfigurationFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'FrontendConfiguration',
      json,
      ($checkedConvert) {
        final val = FrontendConfiguration(
          pleroma: $checkedConvert(
              'pleroma_fe',
              (v) => v == null
                  ? null
                  : PleromaFrontendConfiguration.fromJson(
                      v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {'pleroma': 'pleroma_fe'},
    );

Map<String, dynamic> _$FrontendConfigurationToJson(
        FrontendConfiguration instance) =>
    <String, dynamic>{
      'pleroma_fe': instance.pleroma,
    };
