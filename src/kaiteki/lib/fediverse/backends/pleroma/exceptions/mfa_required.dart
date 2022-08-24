class MfaRequiredException implements Exception {
  final String mfaToken;

  MfaRequiredException(this.mfaToken);
}
