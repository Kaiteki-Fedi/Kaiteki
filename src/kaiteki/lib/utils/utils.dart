import "package:http/http.dart" show Response;
import "package:tuple/tuple.dart";

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

List<Tuple2<Type, StackTrace>> collectStackTraces(dynamic error) {
  // ignore: avoid_dynamic_calls
  final stackTrace = error.stackTrace;
  final list = <Tuple2<Type, StackTrace>>[
    if (stackTrace is StackTrace) Tuple2(error.runtimeType, stackTrace),
  ];

  // ignore: avoid_dynamic_calls
  if (error.innerError != null) {
    // ignore: avoid_dynamic_calls
    final children = collectStackTraces(error.innerError);
    list.addAll(children);
  }

  return list;
}
