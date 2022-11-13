import 'dart:convert';

import 'package:http/http.dart';
import 'package:kaiteki/utils/extensions/string.dart';
import 'package:oauth1/oauth1.dart';
// ignore: implementation_imports
import 'package:oauth1/src/authorization_header_builder.dart';

abstract class AuthenticationData {
  /// Apply all necessary data to the outgoing HTTP request.
  BaseRequest applyTo(BaseRequest request);
}

// TODO(Craftplacer): Make MastodonAuthenticationData final, with copyWith method.
class MastodonAuthenticationData implements AuthenticationData {
  String clientId;
  String clientSecret;
  String? accessToken;

  MastodonAuthenticationData(
    this.clientId,
    this.clientSecret, {
    this.accessToken,
  });

  @override
  BaseRequest applyTo(BaseRequest request) {
    if (accessToken.isNotNullOrEmpty) {
      request.headers["Authorization"] = "Bearer $accessToken";
    }

    return request;
  }
}

class MisskeyAuthenticationData implements AuthenticationData {
  final String token;

  const MisskeyAuthenticationData(this.token);

  @override
  BaseRequest applyTo(BaseRequest request) {
    if (token.isNullOrEmpty) return request;

    if (request is Request) {
      // TODO(Craftplacer): we should avoid duplicate (de-)serialization.
      final decoded = jsonDecode(request.body);
      decoded["i"] = token;

      final encoded = jsonEncode(decoded);
      request.body = encoded;
    } else if (request is MultipartRequest) {
      request.fields["i"] = token;
    }

    return request;
  }
}

class TwitterAuthenticationData implements AuthenticationData {
  final Credentials credentials;
  final ClientCredentials clientCredentials;

  TwitterAuthenticationData(this.credentials, this.clientCredentials);

  @override
  BaseRequest applyTo(BaseRequest request) {
    final ahb = AuthorizationHeaderBuilder()
      ..signatureMethod = SignatureMethods.hmacSha1
      ..clientCredentials = clientCredentials
      ..credentials = credentials
      ..method = request.method
      ..url = request.url.toString();

    request.headers["Authorization"] = ahb.build().toString();
    return request;
  }
}
