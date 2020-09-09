import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/model/login_result.dart';

typedef MfaCallback = Future<String> Function();
typedef LoginCallback = Future<LoginResult> Function(
  String instance,
  String username,
  String password,
  MfaCallback mfaCallback,
  AccountContainer accounts,
);