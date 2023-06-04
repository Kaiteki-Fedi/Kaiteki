import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';
import 'package:kaiteki_core/src/social/backends/twitter/v2/model/user.dart';
import 'package:kaiteki_core/src/social/backends/twitter/v2/responses/response.dart';

part 'retweet_response.g.dart';

typedef RetweetingUsersResponse = Response<List<User>>;
typedef RetweetResponse = Response<RetweetResponseData>;

@JsonSerializable(createToJson: false)
class RetweetResponseData {
  final bool retweeted;

  // ignore: avoid_positional_boolean_parameters
  const RetweetResponseData(this.retweeted);

  factory RetweetResponseData.fromJson(JsonMap json) =>
      _$RetweetResponseDataFromJson(json);
}
