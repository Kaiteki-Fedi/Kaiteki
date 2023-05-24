import "package:http/http.dart" show Response;

typedef JsonMap = Map<String, dynamic>;

void checkResponse(Response response) {
  assert(
    200 <= response.statusCode && response.statusCode < 400,
    "Server returned an unsuccessful response:\n${response.body}",
  );
}

bool isUnsuccessfulStatusCode(int code) {
  return 400 <= code && code < 600;
}

List<(Type, StackTrace)> collectStackTraces(dynamic error) {
  // ignore: avoid_dynamic_calls
  final stackTrace = error.stackTrace;
  final list = <(Type, StackTrace)>[
    if (stackTrace is StackTrace) (error.runtimeType, stackTrace),
  ];

  // ignore: avoid_dynamic_calls
  if (error.innerError != null) {
    // ignore: avoid_dynamic_calls
    final children = collectStackTraces(error.innerError);
    list.addAll(children);
  }

  return list;
}
