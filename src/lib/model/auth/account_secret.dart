class AccountSecret {
  String instance;
  String username;
  String accessToken;

  AccountSecret(String instance, String username, String accessToken) {
    assert(instance != null);
    this.instance = instance;

    assert(username != null);
    this.username = username;

    assert(accessToken != null);
    this.accessToken = accessToken;
  }
}