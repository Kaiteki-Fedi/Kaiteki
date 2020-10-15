import 'package:kaiteki/api/clients/mastodon_client.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/utils/logger.dart';

/// A class that holds login routines for each instance type, for the time being.
class LoginFunctions {
  static Future<ClientSecret> getClientSecret(PleromaClient client, String instance) async {
    var clientSecret = await ClientSecret.getSecret(instance);
    if (clientSecret == null)

      clientSecret = await createClientSecret(client, instance);

    return clientSecret;
  }

  static Future<ClientSecret> createClientSecret(PleromaClient client, String instance) async {
    Logger.info("creating new application on $instance");

    var application = await client.createApplication(
      instance,
      Constants.appName,
      Constants.appWebsite,
      "urn:ietf:wg:oauth:2.0:oob",
      Constants.defaultScopes,
    );

    var clientSecret = ClientSecret(
      instance,
      application.clientId,
      application.clientSecret,
    );

    try {
      await clientSecret.save();
    } catch (e) {
      print("Failed to save client secret:\n$e");
    }

    return clientSecret;
  }
}