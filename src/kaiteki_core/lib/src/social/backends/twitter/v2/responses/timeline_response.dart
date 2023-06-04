import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';
import 'package:kaiteki_core/src/social/backends/twitter/v2/model/tweet.dart';
import 'response.dart';

part 'timeline_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class TimelineResponse extends Response<List<Tweet>> {
  final TimelineResponseMeta meta;

  const TimelineResponse({
    required super.data,
    required this.meta,
    super.includes,
  });

  factory TimelineResponse.fromJson(JsonMap json) =>
      _$TimelineResponseFromJson(json);
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
