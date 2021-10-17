import 'package:json_annotation/json_annotation.dart';

part 'pleroma_frontend_configuration.g.dart';

@JsonSerializable()
class PleromaFrontendConfiguration {
  final String logo;
  final String background;

  factory PleromaFrontendConfiguration.fromJson(Map<String, dynamic> json) =>
      _$PleromaFrontendConfigurationFromJson(json);

  PleromaFrontendConfiguration({
    required this.logo,
    required this.background,
  });

  Map<String, dynamic> toJson() => _$PleromaFrontendConfigurationToJson(this);
}
