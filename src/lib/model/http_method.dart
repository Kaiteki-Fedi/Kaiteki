enum HttpMethod {
  GET,
  POST
}

extension HttpMethodExtensions on HttpMethod {
  String toMethodString() {
    switch (this) {
      case HttpMethod.GET: return "GET";
      case HttpMethod.POST: return "POST";
      default: throw "Given HttpMethod is out of bounds.";
    }
  }
}