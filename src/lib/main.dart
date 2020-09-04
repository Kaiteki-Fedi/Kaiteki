import 'package:flutter/material.dart';
import 'package:kaiteki/app.dart';
import 'package:kaiteki/repositories/account_secret_repository.dart';

void main() async {
  // we need to run this to be able to get access to SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  // fetch async resources e.g. user data
  var accountRepository = await AccountSecretRepository.getInstance();
  var notifications = await initializeNotifications();

  // construct app
  var app = KaitekiApp(
    accountRepository,
    null,
    notifications,
  );

  // run.
  runApp(app);
}
}