import "package:kaiteki/common.dart";
import "package:kaiteki/model/auth/account.dart";

class LoginResult {
  final TraceableError? error;
  final Account? account;
  bool get aborted => !successful && error == null;
  bool get successful => account != null;

  const LoginResult.successful(this.account) : error = null;

  const LoginResult.failed(this.error) : account = null;

  const LoginResult.aborted()
      : account = null,
        error = null;
}
