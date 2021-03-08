import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart';
import 'package:kaiteki/fediverse/api/api_type.dart';
import 'package:kaiteki/fediverse/api/exceptions/api_exception.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/logger.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/authentication_data.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/model/http_method.dart';
import 'package:kaiteki/utils/extensions/string.dart';
import 'package:kaiteki/utils/utils.dart';

typedef T DeserializeFromJson<T>(Map<String, dynamic> json);

/// Class that contains basic properties and methods for building a Fediverse client.
abstract class FediverseClientBase<AuthData extends AuthenticationData> {
  static var _logger = getLogger("FediverseClientBase");

  String get baseUrl {
    if (instance == null) throw "Tried to return a null instance as base URL.";

    return "https://$instance";
  }

  AuthData authenticationData;
  String instance;
  ApiType get type;

  /// Sets the data used for requests to a server.
  Future<void> setClientAuthentication(ClientSecret secret);

  /// Sets the data used for requests to a server.
  Future<void> setAccountAuthentication(AccountSecret secret);

  Future<T> sendJsonRequest<T>(
    HttpMethod method,
    String endpoint,
    DeserializeFromJson<T> toObject, {
    Object body,
  }) async {
    var requestBodyJson = body == null ? null : jsonEncode(body);
    var requestContentType = body == null ? null : "application/json";

    var response = await sendRequest(
      method,
      endpoint,
      body: requestBodyJson,
      contentType: requestContentType,
    );

    var bodyText = await response.stream.bytesToString();
    var bodyJson = jsonDecode(bodyText);

    if (toObject == null) return null;

    return toObject.call(bodyJson);
  }

  Future<Iterable<T>> sendJsonRequestMultiple<T>(
    HttpMethod method,
    String endpoint,
    DeserializeFromJson<T> toObject, {
    Object body,
  }) async {
    var requestBodyJson = body == null ? null : jsonEncode(body);
    var requestContentType = body == null ? null : "application/json";

    var response = await sendRequest(
      method,
      endpoint,
      body: requestBodyJson,
      contentType: requestContentType,
    );

    var bodyText = await response.stream.bytesToString();
    var bodyJson = jsonDecode(bodyText);

    return bodyJson.map<T>((json) => toObject.call(json));
  }

  Future<StreamedResponse> sendRequest(
    HttpMethod method,
    String endpoint, {
    String body,
    String contentType,
  }) async {
    var methodString = method.toMethodString();
    var url = Uri.parse("$baseUrl/$endpoint");
    var request = Request(methodString, url);

    if (body != null) request.body = body;

    // We don't tamper with the "User-Agent" header on "web binaries", because
    // that triggers CORS killing our request.
    if (!kIsWeb) {
      request.headers["User-Agent"] = Constants.userAgent;
    }

    if (contentType.isNotNullOrEmpty) {
      request.headers["Content-Type"] = contentType;
    }

    // apply required authentication data if available
    if (authenticationData != null) {
      authenticationData.applyTo(request);
    }

    var response = await request.send();

    try {
      checkResponse(response);
      return response;
    } catch (ex) {
      _logger.e("Request failed", ex);
      return null;
    }
  }

  void checkResponse(StreamedResponse response) {
    if (Utils.isUnsuccessfulStatusCode(response.statusCode)) {
      throw ApiException(response.statusCode);
    }
  }

  @deprecated
  Map<String, String> getHeaders({String contentType}) => Map<String, String>();
}
