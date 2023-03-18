import "package:kaiteki/fediverse/backends/tumblr/responses/blog.dart";
import "package:kaiteki/fediverse/backends/tumblr/responses/blog_posts.dart";
import "package:kaiteki/fediverse/backends/tumblr/responses/dashboard.dart";
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

  Future<DashboardResponse> getDashboard({
    String? sinceId,
    bool? reblogInfo,
    bool? notesInfo,
    bool? npf,
    Map<String, List<String>> fields = const {},
  }) async {
    final response = await client.sendRequest(
      HttpMethod.get,
      "/v2/user/dashboard",
      query: {
        "since_id": sinceId,
        "reblog_info": reblogInfo,
        "notes_info": notesInfo,
        "npf": npf,
        ..._encodeFields(fields),
      },
    );

    return DashboardResponse.fromJson.fromResponse(response, "response");
  }

  Map<String, String> _encodeFields(Map<String, List<String>> fields) {
    if (fields.isEmpty) return {};
    final entries = fields.entries
        .map((e) => MapEntry("fields[${e.key}]", e.value.join(",")));
    return Map.fromEntries(entries);
  }

  Future<BlogInfoResponse> getBlogInfo(String blogName) async {
    final response = await client.sendRequest(
      HttpMethod.get,
      "/v2/blog/$blogName/info",
    );

    return BlogInfoResponse.fromJson.fromResponse(response, "response");
  }

  Future<BlogPostsResponse> getBlogPosts(String id) async {
    final response = await client.sendRequest(
      HttpMethod.get,
      "/v2/blog/$id/posts",
    );

    return BlogPostsResponse.fromJson.fromResponse(response, "response");
  }

  Future<BlogPostsResponse> search(String query) async {
    final response = await client.sendRequest(
      HttpMethod.get,
      "/api/v2/search/${Uri.encodeComponent(query)}",
      host: "tumblr.com",
    );

    return BlogPostsResponse.fromJson.fromResponse(response, "response");
  }

  Future<void> likePost(String id, [String? reblogKey]) async {
    await client.sendRequest(
      HttpMethod.post,
      "/v2/user/like",
      query: {"id": id, "reblog_key": reblogKey},
    );
  }

  Future<void> unlikePost(String id, [String? reblogKey]) async {
    await client.sendRequest(
      HttpMethod.post,
      "/v2/user/unlike",
      query: {"id": id, "reblog_key": reblogKey},
    );
  }
}
