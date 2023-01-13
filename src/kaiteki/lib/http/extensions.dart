import "dart:convert";

import "package:http/http.dart";
import "package:kaiteki/utils/utils.dart";

typedef DeserializeFromJson<T> = T Function(JsonMap json);
typedef GenericDeserializeFromJson<T, K> = T Function(
  JsonMap json,
  K Function(Object?) jsonFromT,
);

extension KaitekiResponseExtensions on Response {
  bool get isSuccessful => !(400 <= statusCode && statusCode < 600);

  T fromJson<T>(DeserializeFromJson<T> deserialize) {
    final json = jsonDecode(body) as JsonMap;
    return deserialize(json);
  }

  List<T> fromJsonList<T>(DeserializeFromJson<T> deserialize) {
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
