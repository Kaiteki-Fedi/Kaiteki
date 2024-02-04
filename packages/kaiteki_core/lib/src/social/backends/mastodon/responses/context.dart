import 'package:fediverse_objects/mastodon.dart' hide List;
import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';

part 'context.g.dart';

@JsonSerializable(createToJson: false)
class ContextResponse {
  final List<Status> ancestors;

  final List<Status> descendants;

  const ContextResponse(this.ancestors, this.descendants);

  factory ContextResponse.fromJson(JsonMap json) =>
      _$ContextResponseFromJson(json);
}
