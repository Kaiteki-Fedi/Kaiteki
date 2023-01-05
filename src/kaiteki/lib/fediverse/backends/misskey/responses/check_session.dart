import 'package:fediverse_objects/misskey.dart';
import 'package:json_annotation/json_annotation.dart';

part 'check_session.g.dart';

@JsonSerializable()
class CheckSessionResponse {
  final String token;
  final User user;

  const CheckSessionResponse({
    required this.token,
    required this.user,
  });

  factory CheckSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckSessionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckSessionResponseToJson(this);
}
