import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' hide Response;
import 'package:http/http.dart' as http;
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/exceptions/api_exception.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/http/response.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/authentication_data.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/model/http_method.dart';
import 'package:kaiteki/utils/extensions/string.dart';

typedef DeserializeFromJson<T> = T Function(Map<String, dynamic> json);
typedef RequestIntercept = Function(BaseRequest request);

/// Class that contains basic properties and methods for building a Fediverse client.
abstract class FediverseClientBase<AuthData extends AuthenticationData> {
  String get baseUrl => "https://$instance";

  final _http = http.Client();

  AuthData? authenticationData;
  final String instance;
  ApiType get type;

  FediverseClientBase(this.instance);

  /// Sets the data used for requests to a server.
  FutureOr<void> setClientAuthentication(ClientSecret secret) {}

  /// Sets the data used for requests to a server.
  FutureOr<void> setAccountAuthentication(AccountSecret secret);

  Future<void> sendJsonRequestWithoutResponse<T>(
    HttpMethod method,
    String endpoint, {
    Object? body,
  }) async {
    final requestBodyJson = body == null ? null : jsonEncode(body);
    final requestContentType = body == null ? null : "application/json";

    await sendRequest(
      method,
      endpoint,
      body: requestBodyJson,
      contentType: requestContentType,
    );
  }

  Future<T> sendJsonRequest<T>(
    HttpMethod method,
    String endpoint,
    DeserializeFromJson<T> toObject, {
    Object? body,
  }) async {
    final requestBodyJson = body == null ? null : jsonEncode(body);
    final requestContentType = body == null ? null : "application/json";

    final response = await sendRequest(
      method,
      endpoint,
      body: requestBodyJson,
      contentType: requestContentType,
    );

    final bodyJson = await response.getContentJson();
    return toObject.call(bodyJson);
  }

  Future<T> sendJsonMultiPartRequest<T>(
    HttpMethod method,
    String endpoint,
    DeserializeFromJson<T> toObject, {
    Map<String, String> fields = const {},
    List<MultipartFile> files = const [],
  }) async {
    final response = await sendMultiPartRequest(
      method,
      endpoint,
      fields: fields,
      files: files,
    );

    final bodyJson = await response.getContentJson();
    return toObject.call(bodyJson);
  }

  Future<Iterable<T>> sendJsonRequestMultiple<T>(
    HttpMethod method,
    String endpoint,
    DeserializeFromJson<T> toObject, {
    Object? body,
  }) async {
    final requestBodyJson = body == null ? null : jsonEncode(body);
    final requestContentType = body == null ? null : "application/json";

    final response = await sendRequest(
      method,
      endpoint,
      body: requestBodyJson,
      contentType: requestContentType,
    );

    final bodyJson = await response.getContentJson();
    return bodyJson.map<T>((json) => toObject.call(json));
  }

  Future<Response> sendRequest(
    HttpMethod method,
    String endpoint, {
    String? body,
    String? contentType,
    RequestIntercept? intercept,
  }) async {
    final methodString = method.toString();
    final url = _getUri(endpoint);
    final request = Request(methodString, url);

    if (contentType.isNotNullOrEmpty) {
      request.headers["Content-Type"] = contentType!;
    }

    if (body != null) request.body = body;

    _tamperRequest(request, intercept);

    final httpResponse = await _http.send(request);
    final response = Response(httpResponse);
    await checkResponse(response);
    return response;
  }

  Uri _getUri(String endpoint) {
    final endpointUrl = Uri.tryParse(endpoint);
    if (endpointUrl?.host.isNotEmpty == true) return endpointUrl!;
    return Uri.parse("$baseUrl/$endpoint");
  }

  /// Adds default request data
  void _tamperRequest(http.BaseRequest request, RequestIntercept? intercept) {
    // We don't tamper with the "User-Agent" header on "web binaries", because
    // that triggers CORS killing our request.
    if (!kIsWeb) {
      request.headers["User-Agent"] = consts.userAgent;
    }

    // apply required authentication data if available
    if (authenticationData != null) {
      authenticationData!.applyTo(request);
    }

    intercept?.call(request);
  }

  Future<Response> sendMultiPartRequest(
    HttpMethod method,
    String endpoint, {
    RequestIntercept? intercept,
    Map<String, String> fields = const {},
    List<MultipartFile> files = const [],
  }) async {
    final methodString = method.toString();
    final url = _getUri(endpoint);
    final request = http.MultipartRequest(methodString, url);

    request.files.addAll(files);
    request.fields.addAll(fields);

    _tamperRequest(request, intercept);

    final httpResponse = await _http.send(request);
    final response = Response(httpResponse);
    await checkResponse(response);
    return response;
  }

  Future<void> checkResponse(Response response) async {
    if (!response.isSuccessful) {
      throw ApiException.fromResponse(response.response);
    }
  }
}
