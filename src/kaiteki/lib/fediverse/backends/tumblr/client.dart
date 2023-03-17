import "package:kaiteki/fediverse/backends/tumblr/responses/token.dart";
import "package:kaiteki/fediverse/backends/tumblr/responses/user_info.dart";
import "package:kaiteki/http/http.dart";

class TumblrClient {
  late final KaitekiClient client;

  String? accessToken;

  TumblrClient() {
    client = KaitekiClient(
      baseUri: Uri(scheme: "https", host: "api.tumblr.com"),
      intercept: (request) {
        if (accessToken != null) {
          request.headers["Authorization"] = "Bearer $accessToken";
        }
      },
    );
  }

  Future<TokenResponse> getToken({
    required String clientId,
    required String clientSecret,
    required String code,
    String? redirectUri,
    String grantType = "authorization_code",
  }) async {
    final response = await client.sendRequest(
      HttpMethod.post,
      "/v2/oauth2/token",
      body: {
        "client_id": clientId,
        "client_secret": clientSecret,
        "code": code,
        "redirect_uri": redirectUri,
        "grant_type": "authorization_code",
      }.jsonBody,
    );

    return TokenResponse.fromJson.fromResponse(response);
  }

  Future<UserInfoResponse> getUserInfo() async {
    final response = await client.sendRequest(
      HttpMethod.get,
      "/v2/user/info",
    );

    return UserInfoResponse.fromJson.fromResponse(response, "response");
  }
}
