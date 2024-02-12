import 'package:json_annotation/json_annotation.dart';

part 'instance_statistics.g.dart';

@JsonSerializable()
class InstanceStatistics {
  /// Users registered on this instance.
  @JsonKey(name: 'user_count')
  final int userCount;

  /// Statuses authored by users on instance.
  @JsonKey(name: 'status_count')
  final int statusCount;

  /// Domains federated with this instance.
  @JsonKey(name: 'domain_count')
  final int domainCount;

  const InstanceStatistics({
    required this.userCount,
    required this.statusCount,
    required this.domainCount,
  });

  factory InstanceStatistics.fromJson(Map<String, dynamic> json) =>
      _$InstanceStatisticsFromJson(json);

  Map<String, dynamic> toJson() => _$InstanceStatisticsToJson(this);
}
