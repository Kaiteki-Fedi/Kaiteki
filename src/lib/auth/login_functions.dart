import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/api/api_type.dart';
import 'package:kaiteki/api/clients/misskey_client.dart';
import 'package:kaiteki/api/clients/pleroma_client.dart';
import 'package:kaiteki/auth/login_typedefs.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/model/account_compound.dart';
import 'package:kaiteki/model/account_secret.dart';
import 'package:kaiteki/model/client_secret.dart';
import 'package:kaiteki/model/login_result.dart';
import 'package:kaiteki/utils/logger.dart';
import 'package:kaiteki/utils/string_extensions.dart';

/// A class that holds login routines for each instance type, for the time being.
class LoginFunctions {
  static Future<LoginResult> loginPleroma(String instance, String username, String password, MfaCallback mfaCallback, AccountContainer accounts) async {
    var client = PleromaClient()..instance = instance;

    // Retrieve or create client secret
    var clientSecret = await _getClientSecret(client, instance);
    client.clientSecret = clientSecret.clientSecret;
    client.clientId = clientSecret.clientId;

    String accessToken;

    // Try to login and handle error
    var loginResponse = await client.login(username, password);
    accessToken = loginResponse.accessToken;

    if (loginResponse.error.isNotNullOrEmpty) {
      if (loginResponse.error != "mfa_required") {
        return LoginResult.failed(loginResponse.error);
      }

      var code = await mfaCallback.call();

      if (code == null)
        return LoginResult.aborted();

      // TODO: add error-able TOTP screens
      // TODO: make use of a while loop to make this more efficient
      var mfaResponse = await client.respondMfa(
        loginResponse.mfaToken,
        int.parse(code),
      );

      if (mfaResponse.error.isNotNullOrEmpty) {
        return LoginResult.failed(mfaResponse.error);
      } else {
        accessToken = mfaResponse.accessToken;
      }
    }

    // Create and set account secret
    var accountSecret = new AccountSecret(instance, username, accessToken);
    client.accessToken = accountSecret.accessToken;

    // Check whether secrets work, and if we can get an account back
    var account = await client.verifyCredentials();
    if (account == null) {
      return LoginResult.failed("Failed to verify credentials");
    }

    var compound = AccountCompound(accounts, client, account, clientSecret, accountSecret);
    await accounts.addCurrentAccount(compound);

    return LoginResult.successful();
  }

  static Future<ClientSecret> _getClientSecret(PleromaClient client, String instance) async {
    var clientSecret = await ClientSecret.getSecret(instance);

    if (clientSecret == null)
      clientSecret = await _createClientSecret(client, instance);

    return clientSecret;
  }

  static Future<ClientSecret> _createClientSecret(PleromaClient client, String instance) async {
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

  static Future<LoginResult> loginMisskey(String instance, String username, String password, MfaCallback mfaCallback, AccountContainer accounts) async {
    var client = MisskeyClient()..instance = instance;

    var authResponse = await client.signIn(
      username,
      password,
    );

    var mkClientSecret = ClientSecret(instance, "", "", apiType: ApiType.Misskey);

    // Create and set account secret
    var accountSecret = new AccountSecret(instance, username, authResponse.i);
    client.accessToken = accountSecret.accessToken;

    // Check whether secrets work, and if we can get an account back
    var account = await client.showUser(authResponse.id);
    if (account == null) {
      return LoginResult.failed("Failed to retrieve user info");
    }

    var compound = AccountCompound(accounts, client, account, mkClientSecret, accountSecret);
    await accounts.addCurrentAccount(compound);

    return LoginResult.successful();
  }
}