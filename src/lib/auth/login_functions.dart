import 'package:kaiteki/api/clients/mastodon_client.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/repositories/client_secret_repository.dart';
import 'package:kaiteki/utils/logger.dart';

/// A class that holds login routines for each instance type, for the time being.
class LoginFunctions {
  static Future<ClientSecret> getClientSecret(MastodonClient client, String instance, ClientSecretRepository repository) async {
    var clientSecret = repository.get(instance);

    if (clientSecret == null)
      clientSecret = await createClientSecret(client, instance, repository);

    return clientSecret;
  }

  static Future<ClientSecret> createClientSecret(MastodonClient client, String instance, ClientSecretRepository repository) async {
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
      apiType: client.type,
    );

    try {
      await repository.insert(clientSecret);
    } catch (e) {
      Logger.exception(message: "Failed to insert client secret:", ex: e);
    }

    return clientSecret;
  }
}