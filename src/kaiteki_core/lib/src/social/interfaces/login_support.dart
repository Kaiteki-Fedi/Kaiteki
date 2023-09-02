import 'dart:async';

import 'package:kaiteki_core/model.dart';
import 'package:kaiteki_core/utils.dart';

typedef ClientSecret = (String key, String secret);
typedef UserSecret = ({
  String accessToken,
  String? refreshToken,
  String? userId,
});

abstract class LoginSupport {
  const LoginSupport();

  ///
  Future<LoginResult> login(LoginContext context);
}

sealed class LoginResult {
  const LoginResult();
}

/// Information about the registering application.
class ApplicationId {
  final String name;
  final String description;
  final Uri? icon;
  final Uri? website;

  const ApplicationId({
    required this.name,
    required this.description,
    this.icon,
    this.website,
  });
}

class LoginSuccess extends LoginResult {
  final UserSecret? userSecret;
  final ClientSecret? clientSecret;
  final User user;

  const LoginSuccess({
    required this.userSecret,
    required this.user,
    this.clientSecret,
  });
}

class LoginAborted extends LoginResult {
  const LoginAborted();
}

class LoginFailure extends LoginResult {
  final TraceableError error;

  const LoginFailure(this.error);
}

class LoginContext {
  final ClientSecret? clientSecret;
  final CredentialsCallback requestCredentials;
  final CodeCallback requestCode;
  final OAuthCallback? requestOAuth;
  final OpenUrlCallback openUrl;
  final ApplicationId application;

  const LoginContext({
    this.clientSecret,
    required this.requestCredentials,
    required this.requestCode,
    required this.requestOAuth,
    required this.application,
    required this.openUrl,
  });
}

typedef CodeCallback = Future<String?> Function(
  CodePromptOptions options, [
  CodeSubmitCallback? onSubmit,
]);

typedef CodeSubmitCallback = FutureOr<void> Function(String totp);

typedef CredentialsCallback = Future<Credentials?> Function([
  CredentialsSubmitCallback? onSubmit,
]);

typedef CredentialsSubmitCallback = FutureOr<void> Function(
  Credentials? credentials,
);

typedef OAuthCallback = Future<Map<String, String>?> Function(
  GenerateOAuthUrlCallback generateUrl,
);

typedef OpenUrlCallback = FutureOr<void> Function(Uri url);

typedef OAuthUrlCreatedCallback = FutureOr<void> Function(
  Uri oauthUrl,
  Function() abort,
);

typedef GenerateOAuthUrlCallback = Future<Uri> Function(Uri oauthUrl);

class CodePromptOptions {
  final bool numericOnly;
  final int? length;
  final CodePromptLabel label;

  /// Creates a free-form code prompt.
  const CodePromptOptions({
    this.numericOnly = false,
    this.length,
    this.label = CodePromptLabel.code,
  });

  const CodePromptOptions.numericOnly(
    this.length, [
    this.label = CodePromptLabel.code,
  ]) : numericOnly = true;
}

enum CodePromptLabel {
  totp,
  pin,
  token,
  code,
}

class Credentials {
  final String username;
  final String password;

  const Credentials(this.username, this.password);

  @override
  bool operator ==(Object other) =>
      other is Credentials &&
      username == other.username &&
      password == other.password;

  @override
  int get hashCode => username.hashCode ^ password.hashCode;
}
