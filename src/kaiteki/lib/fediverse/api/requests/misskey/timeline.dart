import 'package:json_annotation/json_annotation.dart';
part 'timeline.g.dart';

@JsonSerializable(includeIfNull: false)
class MisskeyTimelineRequest {
  final int limit;
  final String? sinceId;
  final String? untilId;
  final int? sinceDate;
  final int? untilDate;
  final bool includeMyRenotes;
  final bool includeLocalRenotes;
  final bool? withFiles;
  final bool? excludeNsfw;
  final Iterable<String>? fileType;

  MisskeyTimelineRequest({
    this.excludeNsfw,
    this.fileType,
    this.limit = 10,
    this.sinceId,
    this.untilId,
    this.sinceDate,
    this.untilDate,
    this.includeMyRenotes = true,
    this.includeLocalRenotes = true,
    this.withFiles,
  });

  Map<String, dynamic> toJson() => _$MisskeyTimelineRequestToJson(this);
}
