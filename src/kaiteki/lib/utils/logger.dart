/// Simple class for providing logging functions.
///
/// Might get expanded upon
class Logger {
  static void debug(String message) => print("(debug) $message");
  static void warning(String message) => print("(warn) $message");
  static void info(String message) => print("(info) $message");
  static void error(String message) => print("(error) $message");
  static void exception({String message, Error error}) {
    print("(error) $message: $error");
  }
}
