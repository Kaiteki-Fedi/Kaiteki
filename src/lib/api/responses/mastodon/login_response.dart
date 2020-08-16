class LoginResponse {
  String accessToken;
  int expiresIn;
  String me;
  String refreshToken;
  String scope;
  String tokenType;
  String error;
  String mfaToken;
  List<String> supportedChallengeTypes;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json["access_token"];
    expiresIn = json["expires_in"];
    me = json["me"];
    refreshToken = json["refresh_token"];
    scope = json["scope"];
    tokenType = json["token_type"];
    error = json["error"];
    mfaToken = json["mfa_token"];
  }
}