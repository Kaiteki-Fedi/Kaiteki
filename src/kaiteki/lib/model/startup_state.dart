import "package:kaiteki/model/auth/account_key.dart";

sealed class StartupState {
  const StartupState();
}

class StartupLoadingDatabase extends StartupState {
  const StartupLoadingDatabase();
}

class StartupLoadingAccounts extends StartupState {
  const StartupLoadingAccounts();
}

class StartupStarting extends StartupState {
  const StartupStarting();
}

class StartupSignIn extends StartupState {
  final AccountKey accountKey;

  const StartupSignIn(this.accountKey);
}
