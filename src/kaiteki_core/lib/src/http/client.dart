import 'dart:async';

import 'package:http/http.dart';
import 'package:kaiteki_core/src/http/method.dart';
import 'package:kaiteki_core/src/http/request_body.dart';

typedef CheckResponseCallback = FutureOr<void> Function(Response response);
typedef RequestIntercept = FutureOr<void> Function(BaseRequest request);

/// A custom wrapper around the Dart HTTP client.
///
/// It provides abstractions for easy interfacing with web APIs.
class KaitekiClient {
  final _http = Client();
  final CheckResponseCallback? checkResponse;
  final RequestIntercept? intercept;
  late Uri baseUri;

  static String? userAgent = 'Kaiteki/1.0';

  KaitekiClient({
    required this.baseUri,
    this.checkResponse,
    this.intercept,
  });

  Future<Response> sendRequest(
    HttpMethod method,
    String endpoint, {
    RequestBody? body,
    Map<String, Object?> query = const {},
    RequestIntercept? intercept,
  }) async {
    final url = baseUri.replace(
      path: endpoint,
      queryParameters: _sanitizeQuery(query),
    );
    final request = Request(method.name.toUpperCase(), url);

    if (body != null) {
      request.headers['Content-Type'] = body.contentType;
      request.bodyBytes = body.body;
    }

    _applyUserAgent(request);

    if (this.intercept != null) await this.intercept!(request);
    if (intercept != null) await intercept(request);

    final streamedResponse = await _http.send(request);
    final response = await Response.fromStream(streamedResponse);

    final checkResponse = this.checkResponse;
    if (checkResponse != null) await checkResponse(response);

    return response;
  }

  Future<Response> sendMultipartRequest(
    HttpMethod method,
    String endpoint, {
    Map<String, String> fields = const {},
    List<MultipartFile> files = const [],
    Map<String, Object?> query = const {},
    RequestIntercept? intercept,
  }) async {
    final url = baseUri.replace(
      path: endpoint,
      queryParameters: _sanitizeQuery(query),
    );
    final request = MultipartRequest(method.name.toUpperCase(), url)
      ..files.addAll(files)
      ..fields.addAll(fields);

    _applyUserAgent(request);

    if (this.intercept != null) await this.intercept!(request);
    if (intercept != null) await intercept(request);

    final streamedResponse = await _http.send(request);
    final response = await Response.fromStream(streamedResponse);

    final checkResponse = this.checkResponse;
    if (checkResponse != null) await checkResponse(response);

    return response;
  }

  Map<String, String> _sanitizeQuery(Map<String, Object?> query) {
    final entries = query.entries
        .where((e) => e.value != null)
        .map((e) => MapEntry(e.key, e.value.toString()));
    return Map.fromEntries(entries);
  }

  void _applyUserAgent(BaseRequest request) {
    if (userAgent == null) return;
    request.headers['User-Agent'] = userAgent!;
  }
}
