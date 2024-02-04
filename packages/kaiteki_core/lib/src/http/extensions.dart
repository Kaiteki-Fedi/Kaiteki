import 'dart:convert';

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:kaiteki_core/utils.dart';

typedef DeserializeFromJson<T> = T Function(JsonMap json);
typedef GenericDeserializeFromJson<T, K> = T Function(
  JsonMap json,
  K Function(Object?) jsonFromT,
);

Encoding _getEncodingFromHeaders(Map<String, String> headers) {
  final contentType = headers['content-type'];

  if (contentType == null) return utf8;

  try {
    // This can throw. Thanks Google 👍
    final parsed = MediaType.parse(contentType);
    final charset = parsed.parameters['charset'];
    final encoding = Encoding.getByName(charset);
    if (encoding != null) return encoding;
  } catch (e) {
    // TODO(Craftplacer): log error
  }

  return utf8;
}

extension KaitekiResponseExtensions on Response {
  bool get isSuccessful => !(400 <= statusCode && statusCode < 600);

  T fromJson<T>(DeserializeFromJson<T> deserialize) {
    final encoding = _getEncodingFromHeaders(headers);
    final body = encoding.decode(bodyBytes);
    final json = jsonDecode(body) as JsonMap;
    return deserialize(json);
  }

  List<T> fromJsonList<T>(DeserializeFromJson<T> deserialize) {
    final encoding = _getEncodingFromHeaders(headers);
    final body = encoding.decode(bodyBytes);
    final json = (jsonDecode(body) as List<dynamic>).cast<JsonMap>();
    return json.map(deserialize).toList();
  }
}

extension KaitekiJsonDeserializationResopnseExtensions<T>
    on DeserializeFromJson<T> {
  T fromResponse(Response response) => response.fromJson(this);

  List<T> fromResponseList(Response response) => response.fromJsonList(this);
}

extension KaitekiJsonDeserializationResopnseGenericExtensions<T, K>
    on GenericDeserializeFromJson<T, K> {
  T Function(Response response) fromResponse(K Function(Object?) jsonFromT) {
    return (response) {
      return response.fromJson((j) => this(j, jsonFromT));
    };
  }
}

extension FunctionExtensions<T> on T Function(JsonMap) {
  T Function(Object?) get generic {
    return (obj) => this(obj! as JsonMap);
  }

  List<T>? Function(Object?) get genericList {
    return (obj) {
      if (obj == null) return null;
      final list = obj as List<dynamic>;
      final castedList = list.cast<JsonMap>();
      return castedList.map(this).toList();
    };
  }
}
