import "dart:async";
import "dart:io";

import "package:async/async.dart";
import "package:flutter/material.dart" show ColorScheme;
import "package:flutter/services.dart";
import "package:kaiteki/auth/login_typedefs.dart";
import "package:shelf/shelf.dart";
import "package:shelf/shelf_io.dart";

Future<Map<String, String>?> runOAuthServer(
  OAuthUrlCreatedCallback ready,
  String successPage, {
  bool defaultPort = false,
}) async {
  final requestStream = StreamController<Map<String, String>>();
  HttpServer? server;

  try {
    final handler = const Pipeline().addHandler((request) {
      requestStream.add(request.url.queryParameters);
      return Response(
        200,
        body: successPage,
        headers: {"Content-Type": "text/html; charset=UTF-8"},
      );
    });

    // Start server, close & return when new request comes in
    final port = defaultPort ? 80 : 8080;
    server = await serve(handler, "127.0.0.1", port, shared: true);
    final operation = CancelableOperation.fromFuture(
      requestStream.stream.first,
    );

    await ready(Uri.http("localhost:$port", "/"), operation.cancel);
    return await operation.valueOrCancellation();
  } finally {
    server?.close();
    requestStream.close();
  }
}

/// Fetches the OAuth landing page as well as injects the app's current theme.
Future<String> generateOAuthLandingPage(ColorScheme? colorScheme) async {
  final html = await rootBundle.loadString("assets/oauth-success.html");
  const cssPlaceholder = "/* INSERT */";

  if (colorScheme == null) return html.replaceAll(cssPlaceholder, "");

  final cssBuffer = StringBuffer(":root{")
    ..writeAll(
      {
        "background": colorScheme.background,
        "foreground": colorScheme.onBackground,
        "primary-container": colorScheme.primaryContainer,
        "on-primary-container": colorScheme.onPrimaryContainer,
      }.entries.map((kv) {
        final hex = kv.value.value.toRadixString(16).substring(2);
        return "--${kv.key}: #$hex";
      }),
      ";",
    )
    ..write("}");

  return html.replaceAll(cssPlaceholder, cssBuffer.toString());
}
