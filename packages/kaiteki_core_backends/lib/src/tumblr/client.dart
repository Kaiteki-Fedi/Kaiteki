import 'dart:convert';

import 'package:kaiteki_core/http.dart';

import 'responses/blog.dart';
import 'responses/blog_posts.dart';
import 'responses/dashboard.dart';
import 'responses/token.dart';
import 'responses/user_info.dart';

class TumblrClient {
  late final KaitekiClient client;

  String? accessToken;

  TumblrClient() {
    client = KaitekiClient(
      baseUri: Uri.https('api.tumblr.com'),
      intercept: (request) {
        if (accessToken != null) {
          request.headers['Authorization'] = 'Bearer $accessToken';
        }
      },
    );
  }

  Future<TokenResponse> getToken({
    required String clientId,
    required String clientSecret,
    required String code,
    String? redirectUri,
    String grantType = 'authorization_code',
  }) async {
    final response = await client.sendRequest(
      HttpMethod.post,
      '/v2/oauth2/token',
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'code': code,
        'redirect_uri': redirectUri,
        'grant_type': 'authorization_code',
      }.jsonBody,
    );

    return TokenResponse.fromJson.fromResponse(response);
  }

  Future<UserInfoResponse> getUserInfo() async {
    final response = await client.sendRequest(
      HttpMethod.get,
      '/v2/user/info',
    );

    final object = jsonDecode(response.bodyFixed)["response"];
    return UserInfoResponse.fromJson(object);
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
      '/v2/user/dashboard',
      query: {
        'since_id': sinceId,
        'reblog_info': reblogInfo,
        'notes_info': notesInfo,
        'npf': npf,
        ..._encodeFields(fields),
      },
    );

    final object = jsonDecode(response.bodyFixed)["response"];
    return DashboardResponse.fromJson(object);
  }

  Map<String, String> _encodeFields(Map<String, List<String>> fields) {
    if (fields.isEmpty) return {};
    final entries = fields.entries
        .map((e) => MapEntry('fields[${e.key}]', e.value.join(',')));
    return Map.fromEntries(entries);
  }

  Future<BlogInfoResponse> getBlogInfo(String blogName) async {
    final response = await client.sendRequest(
      HttpMethod.get,
      '/v2/blog/$blogName/info',
    );

    final object = jsonDecode(response.bodyFixed)["response"];
    return BlogInfoResponse.fromJson(object);
  }

  Future<BlogPostsResponse> getBlogPosts(String id) async {
    final response = await client.sendRequest(
      HttpMethod.get,
      '/v2/blog/$id/posts',
    );

    final object = jsonDecode(response.bodyFixed)["response"];
    return BlogPostsResponse.fromJson(object);
  }

  Future<BlogPostsResponse> search(String query) async {
    // FIXME(Craftplacer): original host was "tumblr.com"
    final response = await client.sendRequest(
      HttpMethod.get,
      '/api/v2/search/${Uri.encodeComponent(query)}',
    );

    final object = jsonDecode(response.bodyFixed)["response"];
    return BlogPostsResponse.fromJson(object);
  }

  Future<void> likePost(String id, [String? reblogKey]) async {
    await client.sendRequest(
      HttpMethod.post,
      '/v2/user/like',
      query: {'id': id, 'reblog_key': reblogKey},
    );
  }

  Future<void> unlikePost(String id, [String? reblogKey]) async {
    await client.sendRequest(
      HttpMethod.post,
      '/v2/user/unlike',
      query: {'id': id, 'reblog_key': reblogKey},
    );
  }
}
