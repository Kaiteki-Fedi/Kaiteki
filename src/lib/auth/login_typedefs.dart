import 'package:flutter/painting.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/model/auth/login_result.dart';

typedef MfaCallback = Future<String> Function();
typedef LoginCallback = Future<LoginResult> Function(
  String instance,
  String username,
  String password,
  MfaCallback mfaCallback,
  AccountContainer accounts,
);

typedef requestAvatar = Future<ImageProvider> Function(String instance, String username);