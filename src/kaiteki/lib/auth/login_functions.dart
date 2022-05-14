import 'package:kaiteki/constants.dart';
import 'package:kaiteki/fediverse/backends/mastodon/client.dart';
import 'package:kaiteki/logger.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/repositories/client_secret_repository.dart';

final _logger = getLogger("LoginFunctions");

Future<ClientSecret> getClientSecret(
  MastodonClient client,
  String instance,
  ClientSecretRepository repository,
) async {
  return repository.get(instance) ??
      await createClientSecret(
        client,
        instance,
        repository,
      );
}

Future<ClientSecret> createClientSecret(
  MastodonClient client,
  String instance,
  ClientSecretRepository repository,
) async {
  _logger.v("creating new application on $instance");

  final application = await client.createApplication(
    instance,
    Constants.appName,
    Constants.appWebsite,
    "urn:ietf:wg:oauth:2.0:oob",
    Constants.defaultScopes,
  );

  final clientSecret = ClientSecret(
    instance,
    application.clientId!,
    application.clientSecret!,
    apiType: client.type,
  );

  try {
    await repository.insert(clientSecret);
  } catch (e) {
    _logger.e("Failed to insert client secret", e);
  }

  return clientSecret;
}
