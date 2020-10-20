import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kaiteki/app.dart';
import 'package:kaiteki/repositories/account_secret_repository.dart';
import 'package:kaiteki/repositories/client_secret_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  // we need to run this to be able to get access to SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  // fetch async resources e.g. user data
  var accountRepository = await AccountSecretRepository.getInstance();
  var clientRepository = await ClientSecretRepository.getInstance();


  // construct app
  var app = KaitekiApp(
    accountSecrets: accountRepository,
    clientSecrets: clientRepository,
    notifications: await initializeNotifications(),
  );

  // run.
  runApp(app);
}

Future<FlutterLocalNotificationsPlugin> initializeNotifications() async {
  if (kIsWeb)
    return null;

  var plugin = FlutterLocalNotificationsPlugin();
  var initSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_kaiteki"),
      iOS: IOSInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
      ),
  );

  await plugin.initialize(initSettings);

  return plugin;
}