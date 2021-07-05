enum HttpMethod {
  get,
  post,
  put,
  delete,
}

extension HttpMethodExtensions on HttpMethod {
  String toMethodString() {
    switch (this) {
      case HttpMethod.get:
        return "GET";
      case HttpMethod.post:
        return "POST";
      case HttpMethod.put:
        return "PUT";
      case HttpMethod.delete:
        return "DELETE";
      default:
        throw "Given HttpMethod is out of bounds.";
    }
  }
}
