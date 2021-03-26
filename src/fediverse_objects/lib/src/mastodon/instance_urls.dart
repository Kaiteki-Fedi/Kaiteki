import 'package:json_annotation/json_annotation.dart';
part 'instance_urls.g.dart';

@JsonSerializable()
class MastodonInstanceUrls {
  /// Websockets address for push streaming.
  @JsonKey(name: 'streaming_api')
  final String streamingApi;

  MastodonInstanceUrls({required this.streamingApi});

  factory MastodonInstanceUrls.fromJson(Map<String, dynamic> json) =>
      _$MastodonInstanceUrlsFromJson(json);

  Map<String, dynamic> toJson() => _$MastodonInstanceUrlsToJson(this);
}
