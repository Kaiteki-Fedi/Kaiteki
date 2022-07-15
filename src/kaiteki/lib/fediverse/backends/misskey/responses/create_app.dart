import 'package:json_annotation/json_annotation.dart';

part 'create_app.g.dart';

@JsonSerializable()
class MisskeyCreateAppResponse {
  final String id;
  final String name;
  final String callbackUrl;
  final List<String> permission;
  final String secret;

  MisskeyCreateAppResponse({
    required this.id,
    required this.name,
    required this.callbackUrl,
    required this.permission,
    required this.secret,
  });

  factory MisskeyCreateAppResponse.fromJson(Map<String, dynamic> json) =>
      _$MisskeyCreateAppResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyCreateAppResponseToJson(this);
}
