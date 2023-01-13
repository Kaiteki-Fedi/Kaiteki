class OAuthToken {
  final String token;
  final String tokenSecret;
  final bool callbackConfirmed;

  const OAuthToken({
    required this.token,
    required this.tokenSecret,
    required this.callbackConfirmed,
  });
}
