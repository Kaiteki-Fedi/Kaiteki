class LoginResult {
  String? reason;
  bool successful = true;
  bool aborted = false;

  LoginResult.successful();

  LoginResult.failed(this.reason) {
    successful = false;
  }

  LoginResult.aborted() {
    aborted = true;
  }
}
