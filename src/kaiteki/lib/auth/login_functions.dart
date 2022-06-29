import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'package:kaiteki/auth/login_typedefs.dart';
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/fediverse/backends/mastodon/client.dart';
import 'package:kaiteki/logger.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/repositories/client_secret_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

final _logger = getLogger("LoginFunctions");

Future<ClientSecret> getClientSecret(
  MastodonClient client,
  String instance,
  ClientSecretRepository repository, [
  String? redirectUri,
]) async {
  return repository.get(instance) ??
      await createClientSecret(
        client,
        instance,
        repository,
        redirectUri,
      );
}

Future<ClientSecret> createClientSecret(
  MastodonClient client,
  String instance,
  ClientSecretRepository repository, [
  String? redirectUri,
]) async {
  _logger.v("Creating new application on $instance");

  final application = await client.createApplication(
    instance,
    consts.appName,
    consts.appWebsite,
    redirectUri ?? "urn:ietf:wg:oauth:2.0:oob",
    consts.defaultScopes,
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

Future<Map<String, String>?> runOAuthServer(
  OAuthUrlCreatedCallback ready,
) async {
  final requestStream = StreamController<Map<String, String>>();
  HttpServer? server;

  try {
    final sucessPage = await rootBundle.loadString('assets/oauth-success.html');
    final handler = const Pipeline().addHandler((request) {
      requestStream.add(request.url.queryParameters);
      return Response(
        200,
        body: sucessPage,
        headers: {"Content-Type": "text/html; charset=UTF-8"},
      );
    });

    // Start server, close & return when new request comes in
    const port = 8080;
    server = await serve(handler, "localhost", port, shared: true);
    final operation = CancelableOperation.fromFuture(
      requestStream.stream.first,
    );

    ready(Uri.http('localhost:$port', '/'), operation.cancel);
    return await operation.valueOrCancellation();
  } finally {
    server?.close();
    requestStream.close();
  }
}
