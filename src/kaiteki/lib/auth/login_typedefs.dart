import 'package:flutter/painting.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/model/auth/login_result.dart';

typedef MfaCallback = Future<String> Function();
typedef LoginCallback = Future<LoginResult> Function(
  String instance,
  String username,
  String password,
  MfaCallback mfaCallback,
  AccountManager accounts,
);

typedef requestAvatar = Future<ImageProvider> Function(
  String instance,
  String username,
);
