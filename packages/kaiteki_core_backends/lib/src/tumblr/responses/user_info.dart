import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';

import '../entities/user_info.dart';

part 'user_info.g.dart';

@JsonSerializable()
class UserInfoResponse {
  final UserInfo user;

  const UserInfoResponse({
    required this.user,
  });

  factory UserInfoResponse.fromJson(JsonMap json) =>
      _$UserInfoResponseFromJson(json);
}
