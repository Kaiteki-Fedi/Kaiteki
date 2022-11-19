import 'package:http/http.dart';
import 'package:kaiteki/model/auth/authentication_data.dart'
    show AuthenticationData;

class TwitterAuthenticationData extends AuthenticationData {
  final String token;

  final String? userId;

  TwitterAuthenticationData(this.token, this.userId);

  @override
  BaseRequest applyTo(BaseRequest request) =>
      request..headers["Authorization"] = "Bearer $token";
}
