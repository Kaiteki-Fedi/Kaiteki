abstract interface class AccountDeletionSupport {
  /// Attempts to delete the currently signed-in account with the specified
  /// password.
  Future<void> deleteAccount(String password);
}
