import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/fediverse/backends/twitter/v2/model/tweet.dart";
import "package:kaiteki/fediverse/backends/twitter/v2/responses/response.dart";
import "package:kaiteki/utils/utils.dart";

part "timeline_response.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake)
class TimelineResponse extends Response<List<Tweet>> {
  final TimelineResponseMeta meta;

  const TimelineResponse({
    required super.data,
    required this.meta,
    super.includes,
  });

  factory TimelineResponse.fromJson(JsonMap json) =>
      _$TimelineResponseFromJson(json);

  JsonMap toJson() => _$TimelineResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TimelineResponseMeta {
  final String? newestId;
  final String? oldestId;
  final String? nextToken;
  final String? previousToken;
  final int resultCount;

  const TimelineResponseMeta({
    required this.newestId,
    required this.oldestId,
    required this.nextToken,
    required this.previousToken,
    required this.resultCount,
  });

  factory TimelineResponseMeta.fromJson(JsonMap json) =>
      _$TimelineResponseMetaFromJson(json);

  JsonMap toJson() => _$TimelineResponseMetaToJson(this);
}
