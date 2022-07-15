import 'package:tuple/tuple.dart';

class LoginResult {
  final Tuple2<dynamic, StackTrace?>? error;
  final bool successful;
  final bool aborted;

  const LoginResult.successful()
      : successful = true,
        aborted = false,
        error = null;

  const LoginResult.failed(this.error)
      : successful = false,
        aborted = false;

  const LoginResult.aborted()
      : successful = false,
        error = null,
        aborted = true;
}
