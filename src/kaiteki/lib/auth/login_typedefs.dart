import 'dart:async';

typedef MfaCallback = Future<String?> Function();
typedef OAuthCallback = Future<Map<String, String>?> Function(
  GenerateOAuthUrlCallback generateUrl,
);
typedef OAuthUrlCreatedCallback = FutureOr<void> Function(
  Uri oauthUrl,
  Function() abort,
);
typedef GenerateOAuthUrlCallback = Future<Uri> Function(Uri oauthUrl);
