import "package:http/http.dart" as http;

class HttpException implements Exception {
  final int statusCode;
  final String? reasonPhrase;

  const HttpException(this.statusCode, {this.reasonPhrase});

  factory HttpException.fromResponse(http.BaseResponse response) {
    return HttpException(
      response.statusCode,
      reasonPhrase: response.reasonPhrase,
    );
  }

  @override
  String toString() {
    if (reasonPhrase?.isNotEmpty == true) {
      return "$statusCode $reasonPhrase";
    } else {
      return "The server returned an unsuccessful status code: $statusCode";
    }
  }
}
