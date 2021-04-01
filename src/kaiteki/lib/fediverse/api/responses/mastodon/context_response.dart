import 'package:fediverse_objects/mastodon.dart';
import 'package:json_annotation/json_annotation.dart';
part 'context_response.g.dart';

@JsonSerializable(createToJson: false)
class ContextResponse {
  final Iterable<MastodonStatus> ancestors;

  final Iterable<MastodonStatus> descendants;

  const ContextResponse(this.ancestors, this.descendants);

  factory ContextResponse.fromJson(Map<String, dynamic> json) =>
      _$ContextResponseFromJson(json);
}
