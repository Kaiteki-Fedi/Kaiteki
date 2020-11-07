enum HttpMethod {
  GET,
  POST,
  PUT,
  DELETE,
}

extension HttpMethodExtensions on HttpMethod {
  String toMethodString() {
    switch (this) {
      case HttpMethod.GET:
        return "GET";
      case HttpMethod.POST:
        return "POST";
      case HttpMethod.PUT:
        return "PUT";
      case HttpMethod.DELETE:
        return "DELETE";
      default:
        throw "Given HttpMethod is out of bounds.";
    }
  }
}
