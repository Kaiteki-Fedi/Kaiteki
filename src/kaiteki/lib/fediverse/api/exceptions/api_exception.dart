class ApiException implements Exception {
  final int statusCode;

  ApiException(this.statusCode);

  @override
  String toString() {
    return "The server returned an unsuccessful status code: $statusCode";
  }
}
