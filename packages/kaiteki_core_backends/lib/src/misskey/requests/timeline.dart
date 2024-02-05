import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';

part 'timeline.g.dart';

@JsonSerializable(includeIfNull: false, createFactory: false)
class MisskeyTimelineRequest {
  final int? limit;
  final String? sinceId;
  final String? untilId;
  final int? sinceDate;
  final int? untilDate;
  final bool? includeMyRenotes;
  final bool? includeLocalRenotes;
  final bool? withFiles;
  final bool? excludeNsfw;

  MisskeyTimelineRequest({
    this.excludeNsfw,
    this.limit = 10,
    this.sinceId,
    this.untilId,
    this.sinceDate,
    this.untilDate,
    this.includeMyRenotes,
    this.includeLocalRenotes,
    this.withFiles,
  });

  JsonMap toJson() => _$MisskeyTimelineRequestToJson(this);
}
