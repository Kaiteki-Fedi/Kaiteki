import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/fediverse/backends/twitter/v2/model/user.dart";
import "package:kaiteki/fediverse/backends/twitter/v2/responses/response.dart";
import "package:kaiteki/utils/utils.dart";

part "user_response.g.dart";

@JsonSerializable()
class UserResponse extends Response<User> {
  const UserResponse({required super.data});

  factory UserResponse.fromJson(JsonMap json) => _$UserResponseFromJson(json);
}
