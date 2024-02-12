import 'package:json_annotation/json_annotation.dart';

part 'instance_configuration_accounts.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class InstanceConfigurationAccounts {
  final int maxFeaturedTags;

  const InstanceConfigurationAccounts({required this.maxFeaturedTags});

  factory InstanceConfigurationAccounts.fromJson(Map<String, dynamic> json) =>
      _$InstanceConfigurationAccountsFromJson(json);

  Map<String, dynamic> toJson() => _$InstanceConfigurationAccountsToJson(this);
}
