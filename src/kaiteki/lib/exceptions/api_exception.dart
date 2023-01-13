import "package:http/http.dart" as http;
import "package:kaiteki/utils/utils.dart";

class ApiException implements Exception {
  final int statusCode;
  final String? reasonPhrase;

  /// Additional data provided by the server.
  final JsonMap? data;

  ApiException(this.statusCode, {this.reasonPhrase, this.data});

  ApiException.fromResponse(http.BaseResponse response)
      : this(response.statusCode, reasonPhrase: response.reasonPhrase);

  @override
  String toString() {
    if (reasonPhrase?.isNotEmpty == true) {
      return "$statusCode $reasonPhrase";
    } else {
      return "The server returned an unsuccessful status code: $statusCode";
    }
  }
}
