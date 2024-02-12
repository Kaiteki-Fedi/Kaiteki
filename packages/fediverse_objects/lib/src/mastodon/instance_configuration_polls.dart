import 'package:json_annotation/json_annotation.dart';

part 'instance_configuration_polls.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class InstanceConfigurationPolls {
  final int maxOptions;
  final int maxCharactersPerOption;
  final int minExpiration;
  final int maxExpiration;

  factory InstanceConfigurationPolls.fromJson(Map<String, dynamic> json) =>
      _$InstanceConfigurationPollsFromJson(json);

  InstanceConfigurationPolls(this.maxOptions, this.maxCharactersPerOption,
      this.minExpiration, this.maxExpiration);

  Map<String, dynamic> toJson() => _$InstanceConfigurationPollsToJson(this);
}
