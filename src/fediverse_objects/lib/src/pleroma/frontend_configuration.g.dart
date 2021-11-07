// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frontend_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrontendConfiguration _$FrontendConfigurationFromJson(
        Map<String, dynamic> json) =>
    FrontendConfiguration(
      pleroma: json['pleroma_fe'] == null
          ? null
          : PleromaFrontendConfiguration.fromJson(
              json['pleroma_fe'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FrontendConfigurationToJson(
        FrontendConfiguration instance) =>
    <String, dynamic>{
      'pleroma_fe': instance.pleroma,
    };
