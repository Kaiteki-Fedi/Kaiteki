import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';
import 'package:kaiteki_core/src/social/backends/twitter/v2/model/user.dart';
import 'package:kaiteki_core/src/social/backends/twitter/v2/responses/response.dart';

part 'like_response.g.dart';

typedef LikingUsersResponse = Response<List<User>>;
typedef LikeResponse = Response<LikeResponseData>;

@JsonSerializable(createToJson: false)
class LikeResponseData {
  final bool liked;

  // ignore: avoid_positional_boolean_parameters
  const LikeResponseData(this.liked);

  factory LikeResponseData.fromJson(JsonMap json) =>
      _$LikeResponseDataFromJson(json);
}
