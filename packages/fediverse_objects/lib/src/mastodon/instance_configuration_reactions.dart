import 'package:json_annotation/json_annotation.dart';

part 'instance_configuration_reactions.g.dart';

@JsonSerializable()
class InstanceConfigurationReactions {
  @JsonKey(name: 'max_reactions')
  final int maxReactions;

  const InstanceConfigurationReactions({required this.maxReactions});

  factory InstanceConfigurationReactions.fromJson(Map<String, dynamic> json) =>
      _$InstanceConfigurationReactionsFromJson(json);

  Map<String, dynamic> toJson() => _$InstanceConfigurationReactionsToJson(this);
}
