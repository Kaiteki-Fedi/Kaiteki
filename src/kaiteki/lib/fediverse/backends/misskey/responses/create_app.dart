import 'package:json_annotation/json_annotation.dart';

part 'create_app.g.dart';

@JsonSerializable()
class CreateAppResponse {
  final String id;
  final String name;
  final String callbackUrl;
  final List<String> permission;
  final String secret;

  CreateAppResponse({
    required this.id,
    required this.name,
    required this.callbackUrl,
    required this.permission,
    required this.secret,
  });

  factory CreateAppResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateAppResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAppResponseToJson(this);
}
