import 'package:kaiteki/api/api_type.dart';
import 'package:kaiteki/utils/string_extensions.dart';

/// Class that contains basic properties for building a Fediverse client.
abstract class FediverseClientBase {
  String get baseUrl {
    if (instance == null)
      throw "Tried to return a null instance as base URL.";

    return "https://$instance";
  }

  String instance;
  String accessToken;
  String clientId;
  String clientSecret;

  ApiType get type;

  Map<String, String> getHeaders({String contentType}) {
    var headers = Map<String, String>();

    if (contentType.isNotNullOrEmpty)
      headers["Content-Type"] = contentType;

    if (accessToken.isNotNullOrEmpty)
      headers["Authorization"] = "Bearer $accessToken";

    return headers;
  }
}