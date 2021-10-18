import 'package:json_annotation/json_annotation.dart';

part 'instance_urls.g.dart';

@JsonSerializable()
class InstanceUrls {
  /// Websockets address for push streaming.
  @JsonKey(name: 'streaming_api')
  final String streamingApi;

  InstanceUrls({required this.streamingApi});

  factory InstanceUrls.fromJson(Map<String, dynamic> json) =>
      _$InstanceUrlsFromJson(json);

  Map<String, dynamic> toJson() => _$InstanceUrlsToJson(this);
}
