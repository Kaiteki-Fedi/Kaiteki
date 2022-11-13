import 'dart:async';

typedef MfaCallback = Future<T?> Function<T>(MfaSubmitCallback<T> onSubmit);
typedef MfaSubmitCallback<T> = Future<T> Function(String totp);

typedef CredentialsCallback = Future<T?> Function<T>(
  CredentialsSubmitCallback<T> onSubmit,
);
typedef CredentialsSubmitCallback<T> = Future<T> Function(
  Credentials? credentials,
);

typedef OAuthCallback = Future<Map<String, String>?> Function(
  GenerateOAuthUrlCallback generateUrl,
);

typedef OAuthUrlCreatedCallback = FutureOr<void> Function(
  Uri oauthUrl,
  Function() abort,
);

typedef GenerateOAuthUrlCallback = Future<Uri> Function(Uri oauthUrl);

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
