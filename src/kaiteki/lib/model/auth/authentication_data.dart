import 'dart:convert';

import 'package:http/http.dart';
import 'package:kaiteki/utils/extensions/string.dart';

abstract class AuthenticationData {
  /// Apply all necessary data to the outgoing HTTP request.
  Request applyTo(Request request);
}

class MastodonAuthenticationData implements AuthenticationData {
  String clientId;
  String clientSecret;
  String accessToken;

  @override
  Request applyTo(Request request) {
    if (accessToken.isNotNullOrEmpty)
      request.headers["Authorization"] = "Bearer $accessToken";

    return request;
  }
}

class MisskeyAuthenticationData implements AuthenticationData {
  final String token;

  const MisskeyAuthenticationData(this.token);

  @override
  Request applyTo(Request request) {
    if (token.isNullOrEmpty) return request;

    // TODO we should avoid duplicate (de-)serialization.
    var decoded = jsonDecode(request.body);
    decoded["i"] = token;

    var encoded = jsonEncode(decoded);
    request.body = encoded;

    return request;
  }
}
