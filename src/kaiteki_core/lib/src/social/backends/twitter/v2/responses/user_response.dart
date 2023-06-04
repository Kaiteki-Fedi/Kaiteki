import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';
import 'package:kaiteki_core/src/social/backends/twitter/v2/model/user.dart';
import 'response.dart';

part 'user_response.g.dart';

@JsonSerializable(createToJson: false)
class UserResponse extends Response<User> {
  const UserResponse({required super.data});

  factory UserResponse.fromJson(JsonMap json) => _$UserResponseFromJson(json);
}
