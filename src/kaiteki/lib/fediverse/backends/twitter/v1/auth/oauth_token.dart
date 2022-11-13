class OAuthToken {
  final String token;
  final String tokenSecret;
  final bool callbackConfirmed;

  const OAuthToken(this.token, this.tokenSecret, this.callbackConfirmed);
}
