import 'package:json_annotation/json_annotation.dart';
part 'instance_statistics.g.dart';

@JsonSerializable()
class MastodonInstanceStatistics {
  /// Users registered on this instance.
  @JsonKey(name: 'user_count')
  final int userCount;

  /// Statuses authored by users on instance.
  @JsonKey(name: 'status_count')
  final int statusCount;

  /// Domains federated with this instance.
  @JsonKey(name: 'domain_count')
  final int domainCount;

  const MastodonInstanceStatistics({
    required this.userCount,
    required this.statusCount,
    required this.domainCount,
  });

  factory MastodonInstanceStatistics.fromJson(Map<String, dynamic> json) =>
      _$MastodonInstanceStatisticsFromJson(json);

  Map<String, dynamic> toJson() => _$MastodonInstanceStatisticsToJson(this);
}
