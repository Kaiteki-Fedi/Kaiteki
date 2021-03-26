import 'package:fediverse_objects/src/mastodon/field.dart';
import 'package:json_annotation/json_annotation.dart';
part 'source.g.dart';

/// Represents display or publishing preferences of user's own account.
///
/// Returned as an additional entity when verifying and updated credentials, as an attribute of Account.
@JsonSerializable()
class MastodonSource {
  /// Profile bio.
  final String note;

  /// Profile bio.
  final Iterable<MastodonField> fields;

  final String? privacy;

  /// Whether new statuses should be marked sensitive by default.
  final bool? sensitive;

  /// The default posting language for new statuses.
  final String? language;

  // The number of pending follow requests.
  @JsonKey(name: 'follow_requests_count')
  final int? followRequestsCount;

  MastodonSource({
    required this.note,
    required this.fields,
    this.privacy,
    this.sensitive,
    this.language,
    this.followRequestsCount,
  });

  factory MastodonSource.fromJson(Map<String, dynamic> json) =>
      _$MastodonSourceFromJson(json);

  Map<String, dynamic> toJson() => _$MastodonSourceToJson(this);
}
