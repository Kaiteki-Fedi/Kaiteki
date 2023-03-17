import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/fediverse/backends/tumblr/entities/user_info.dart";
import "package:kaiteki/utils/utils.dart";

part "user_info.g.dart";

@JsonSerializable()
class UserInfoResponse {
  final UserInfo user;

  const UserInfoResponse({
    required this.user,
  });

  factory UserInfoResponse.fromJson(JsonMap json) =>
      _$UserInfoResponseFromJson(json);
}
