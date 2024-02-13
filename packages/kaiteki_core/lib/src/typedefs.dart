/// A record that stores an object and optionally a stack trace. Used for
/// storing errors along with their stack trace.
typedef TraceableError = (Object error, StackTrace? stackTrace);

typedef JsonMap = Map<String, dynamic>;
