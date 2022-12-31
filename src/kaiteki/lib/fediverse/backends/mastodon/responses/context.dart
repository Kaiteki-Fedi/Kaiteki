import 'package:fediverse_objects/mastodon.dart' hide List;
import 'package:json_annotation/json_annotation.dart';

part 'context.g.dart';

@JsonSerializable(createToJson: false)
class ContextResponse {
  final List<Status> ancestors;

  final List<Status> descendants;

  const ContextResponse(this.ancestors, this.descendants);

  factory ContextResponse.fromJson(Map<String, dynamic> json) =>
      _$ContextResponseFromJson(json);
}
