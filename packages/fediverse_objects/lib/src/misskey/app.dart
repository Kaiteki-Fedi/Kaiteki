import 'package:json_annotation/json_annotation.dart';
part 'app.g.dart';

@JsonSerializable()
class App {
  final String id;

  final String name;

  final String? callbackUrl;

  final List<String> permission;

  final String? secret;

  final bool? isAuthorized;

  const App({
    required this.id,
    required this.name,
    this.callbackUrl,
    required this.permission,
    this.secret,
    this.isAuthorized,
  });

  factory App.fromJson(Map<String, dynamic> json) => _$AppFromJson(json);
  Map<String, dynamic> toJson() => _$AppToJson(this);
}
