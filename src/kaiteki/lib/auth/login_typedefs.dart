import "dart:async";

typedef CodeCallback = Future<T?> Function<T>(
  CodePromptOptions options,
  CodeSubmitCallback<T> onSubmit,
);
typedef CodeSubmitCallback<T> = Future<T> Function(String totp);

typedef CredentialsCallback = Future<T?> Function<T>(
  CredentialsSubmitCallback<T> onSubmit,
);
typedef CredentialsSubmitCallback<T> = Future<T> Function(
  Credentials? credentials,
);

typedef OAuthCallback = Future<Map<String, String>?> Function(
  GenerateOAuthUrlCallback generateUrl, {
  bool requireDefaultHttpPort,
});

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
