import 'package:kaiteki/model/mfa_data.dart';

class LoginResult {
  String reason;
  bool get failed => reason != null;
  bool pop = true;

  MfaData mfa;

  LoginResult({this.reason, this.pop, this.mfa});
}