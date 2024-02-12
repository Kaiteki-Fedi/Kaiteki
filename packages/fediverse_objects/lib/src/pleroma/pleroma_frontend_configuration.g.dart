// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pleroma_frontend_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaFrontendConfiguration _$PleromaFrontendConfigurationFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'PleromaFrontendConfiguration',
      json,
      ($checkedConvert) {
        final val = PleromaFrontendConfiguration(
          logo: $checkedConvert(
              'logo', (v) => v == null ? null : Uri.parse(v as String)),
          background: $checkedConvert(
              'background', (v) => v == null ? null : Uri.parse(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$PleromaFrontendConfigurationToJson(
        PleromaFrontendConfiguration instance) =>
    <String, dynamic>{
      'logo': instance.logo?.toString(),
      'background': instance.background?.toString(),
    };
