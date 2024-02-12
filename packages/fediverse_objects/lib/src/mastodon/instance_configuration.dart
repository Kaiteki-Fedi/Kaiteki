import 'package:json_annotation/json_annotation.dart';

import 'instance_configuration_accounts.dart';
import 'instance_configuration_media_attachments.dart';
import 'instance_configuration_polls.dart';
import 'instance_configuration_reactions.dart';
import 'instance_configuration_statuses.dart';

part 'instance_configuration.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class InstanceConfiguration {
  /// (Glitch) Limits related to reactions.
  final InstanceConfigurationReactions? reactions;

  /// Limits related to accounts.
  final InstanceConfigurationAccounts? accounts;

  /// Limits related to authoring statuses.
  final InstanceConfigurationStatuses? statuses;

  /// Limits related to polls.
  final InstanceConfigurationPolls? polls;

  /// Hints for which attachments will be accepted.
  final InstanceConfigurationMediaAttachments mediaAttachments;

  const InstanceConfiguration({
    required this.accounts,
    required this.statuses,
    required this.polls,
    required this.mediaAttachments,
    this.reactions,
  });

  factory InstanceConfiguration.fromJson(Map<String, dynamic> json) =>
      _$InstanceConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$InstanceConfigurationToJson(this);
}
