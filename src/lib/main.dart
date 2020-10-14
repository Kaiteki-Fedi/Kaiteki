import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kaiteki/app.dart';
import 'package:kaiteki/repositories/account_secret_repository.dart';

void main() async {
  // we need to run this to be able to get access to SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  // fetch async resources e.g. user data
  var accountRepository = await AccountSecretRepository.getInstance();

  var notifications = null; //await initializeNotifications();

  // construct app
  var app = KaitekiApp(
    accountRepository,
    null,
    notifications,
  );

  // run.
  runApp(app);
}

Future<FlutterLocalNotificationsPlugin> initializeNotifications() async {
  var plugin =  FlutterLocalNotificationsPlugin();
  var initSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: IOSInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
      ),
  );

  await plugin.initialize(initSettings);

  return plugin;
}