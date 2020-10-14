import 'package:json_annotation/json_annotation.dart';
part 'application.g.dart';

@JsonSerializable()
class MastodonApplication {
  @JsonKey(name: "client_id")
  final String clientId;

  @JsonKey(name: "client_secret")
  final String clientSecret;

  final String id;

  final String name;

  @JsonKey(name: "vapid_key")
  final String vapidKey;

  final String website;

  const MastodonApplication({
    this.clientId,
    this.clientSecret,
    this.id,
    this.name,
    this.vapidKey,
    this.website,
  });

  factory MastodonApplication.fromJson(Map<String, dynamic> json) => _$MastodonApplicationFromJson(json);
}