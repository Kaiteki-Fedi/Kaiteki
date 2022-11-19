import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/fediverse/backends/twitter/v2/model/user.dart';
import 'package:kaiteki/fediverse/backends/twitter/v2/responses/response.dart';

part 'like_response.g.dart';

typedef LikingUsersResponse = Response<List<User>>;
typedef LikeResponse = Response<LikeResponseData>;

@JsonSerializable()
class LikeResponseData {
  final bool liked;

  const LikeResponseData(this.liked);

  factory LikeResponseData.fromJson(Map<String, dynamic> json) =>
      _$LikeResponseDataFromJson(json);
}
