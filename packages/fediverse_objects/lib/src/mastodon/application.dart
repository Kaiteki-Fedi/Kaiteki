import 'package:json_annotation/json_annotation.dart';

part 'application.g.dart';

/// Represents an application that interfaces with the REST API to access accounts or post statuses.
@JsonSerializable()
class Application {
  /// Client ID key, to be used for obtaining OAuth tokens
  @JsonKey(name: 'client_id')
  final String? clientId;

  /// Client secret key, to be used for obtaining OAuth tokens
  @JsonKey(name: 'client_secret')
  final String? clientSecret;

  final String? id;

  /// The name of your application.
  final String name;

  /// Used for Push Streaming API.
  ///
  /// Returned with [POST /api/v1/apps](https://docs.joinmastodon.org/methods/apps/#create-an-application). Equivalent to [PushSubscription#server_key](https://docs.joinmastodon.org/entities/pushsubscription/#server_key).
  @JsonKey(name: 'vapid_key')
  final String? vapidKey;

  /// The website associated with your application.
  final String? website;

  const Application({
    required this.name,
    // optional attributes
    this.website,
    this.vapidKey,
    // client attributes
    this.clientId,
    this.clientSecret,
    this.id,
  });

  factory Application.fromJson(Map<String, dynamic> json) =>
      _$ApplicationFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationToJson(this);
}
