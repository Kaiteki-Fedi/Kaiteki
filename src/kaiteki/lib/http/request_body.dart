import "dart:convert";
import "dart:typed_data";

import "package:kaiteki/utils/utils.dart";

/// A class that abstracts the body and content type of a HTTP request.
class RequestBody {
  final String contentType;
  final Uint8List body;

  const RequestBody(this.contentType, this.body);

  factory RequestBody.text(
    String body, [
    String? contentType,
    Encoding encoding = const Utf8Codec(),
  ]) {
    return RequestBody(
      contentType ?? "text/plain",
      Uint8List.fromList(encoding.encode(body)),
    );
  }
}

class UrlEncodedBody implements RequestBody {
  @override
  final Uint8List body;

  @override
  String get contentType => "application/x-www-form-urlencoded";

  factory UrlEncodedBody(Map<String, String> parameters) {
    final text = Uri(queryParameters: parameters).query;
    final bytes = utf8.encode(text);
    final list = Uint8List.fromList(bytes);
    return UrlEncodedBody._(list);
  }

  const UrlEncodedBody._(this.body);
}

extension UrlEncodedBodyExtension<T> on Map<String, String> {
  UrlEncodedBody get urlEncodedBody => UrlEncodedBody(this);
}

class JsonRequestBody implements RequestBody {
  @override
  final Uint8List body;

  @override
  String get contentType => "application/json";

  factory JsonRequestBody(Object object) {
    final json = jsonEncode(object);
    final bytes = utf8.encode(json);
    final list = Uint8List.fromList(bytes);
    return JsonRequestBody._(list);
  }

  const JsonRequestBody._(this.body);
}

extension JsonRequestBodyExtension<T> on JsonMap {
  JsonRequestBody get jsonBody => JsonRequestBody(this);
}
