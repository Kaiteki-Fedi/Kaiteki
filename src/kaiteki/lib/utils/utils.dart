import "package:http/http.dart" show Response;

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

(String username, String? host)? _parseUserHandle(String input) {
  final beginsWithAt = input[0] == "@";
  final atInput = beginsWithAt ? input.substring(1) : input;
  final atSplit = atInput.split("@");

  if (atSplit.length == 2 || (beginsWithAt && atSplit.length == 1)) {
    return (atSplit[0], atSplit.elementAtOrNull(1));
  }

  return null;
}

/// Parses a user handle from a string.
///
/// Providing [String] as the type parameter will require the host to be present for the result to be non-null.
(String username, T host)? parseUserHandle<T extends String?>(String input) {
  final beginsWithAt = input[0] == "@";
  if (beginsWithAt) input = input.substring(1);

  final split = input.split("@");

  if (split.length == 2) return (split[0], split[1] as T);

  // Since there are no two items, we can't have a host.
  if (null is! T) return null;

  if (beginsWithAt && split.length == 1) return (split[0], null as T);

  return null;
}
