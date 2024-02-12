import 'pleroma_frontend_configuration.dart';
import 'package:json_annotation/json_annotation.dart';

part 'frontend_configuration.g.dart';

@JsonSerializable()
class FrontendConfiguration {
  @JsonKey(name: 'pleroma_fe')
  final PleromaFrontendConfiguration? pleroma;

  const FrontendConfiguration({
    required this.pleroma,
  });

  factory FrontendConfiguration.fromJson(Map<String, dynamic> json) =>
      _$FrontendConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$FrontendConfigurationToJson(this);
}
