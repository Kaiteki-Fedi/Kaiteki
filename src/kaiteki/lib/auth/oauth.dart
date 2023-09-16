import "dart:async";
import "dart:convert";
import "dart:html";
import "dart:io";
import "dart:js" as js;
import 'dart:ui_web' as ui_web;

import "package:async/async.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart" show ColorScheme;
import "package:flutter/services.dart";
import "package:kaiteki_core/social.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:shelf/shelf.dart";
import "package:shelf/shelf_io.dart";

Future<Map<String, String>?> runServer(
  OAuthUrlCreatedCallback ready,
  String successPage,
) async {
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
    const port = 8080;
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
Future<String> generateLandingPage(ColorScheme? colorScheme) async {
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

String _getExtraKey(ApiType type, String host) =>
    "oAuthExtra_${type.name}_$host";

Future<void> pushExtra(
  SharedPreferences preferences,
  ApiType type,
  String host,
  Map<String, String> extra,
) async {
  final key = _getExtraKey(type, host);
  final json = jsonEncode(extra);

  await preferences.setString(key, json);
}

Map<String, String>? popExtra(
  SharedPreferences preferences,
  ApiType type,
  String host,
) {
  final key = _getExtraKey(type, host);

  final json = preferences.getString(key);
  if (json == null) return null;

  final map = Map<String, String>.from(jsonDecode(json));

  preferences.remove(key);

  return map;
}

bool? get isProtocolHandlerRegistered {
  if (!kIsWeb) return null;
  final value = js.context["isProtocolHandlerRegistered"];
  if (value is bool) return value;
  return null;
}

Uri? getBaseUri() {
  // We cannot read the query parameters if we're using the hash strategy.
  if (kIsWeb && !_isUsingHashUrlStrategy) {
    // get base tag from head
    final base = document.head?.querySelector("base")?.attributes["href"];
    final current = Uri.tryParse(window.location.href);
    if (current != null) {
      return base == null ? current : current.resolve(base);
    }
  }

  if (isProtocolHandlerRegistered == true) {
    // HACK(Craftplacer): https://github.com/flutter/flutter/issues/124045
    return Uri(scheme: "web+kaitekisocial", host: "go-router-is-poop");
  }

  return null;
}

bool get _isUsingHashUrlStrategy =>
    ui_web.urlStrategy is ui_web.HashUrlStrategy;

Uri? getRedirectUri(ApiType type, String host) {
  final baseUri = getBaseUri();

  if (baseUri == null) return null;

  final pathSegments = ["oauth", type.name, host];

  if (kIsWeb && _isUsingHashUrlStrategy) {
    return baseUri.replace(fragment: '/${pathSegments.join('/')}');
  }

  return baseUri.replace(pathSegments: pathSegments);
}
