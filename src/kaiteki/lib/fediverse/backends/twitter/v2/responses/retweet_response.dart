import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/fediverse/backends/twitter/v2/model/user.dart";
import "package:kaiteki/fediverse/backends/twitter/v2/responses/response.dart";
import "package:kaiteki/utils/utils.dart";

part "retweet_response.g.dart";

typedef RetweetingUsersResponse = Response<List<User>>;
typedef RetweetResponse = Response<RetweetResponseData>;

@JsonSerializable()
class RetweetResponseData {
  final bool retweeted;

  // ignore: avoid_positional_boolean_parameters
  const RetweetResponseData(this.retweeted);

  factory RetweetResponseData.fromJson(JsonMap json) =>
      _$RetweetResponseDataFromJson(json);
}
