import "dart:async";
import "dart:convert";

import "package:flutter/material.dart" show ColorScheme;
import "package:flutter/services.dart";
import "package:kaiteki/auth/oauth_native.dart"
    if (dart.library.html) "package:kaiteki/auth/oauth_web.dart";
import "package:kaiteki_core_backends/kaiteki_core_backends.dart";
import "package:shared_preferences/shared_preferences.dart";

export "package:kaiteki/auth/oauth_native.dart"
    if (dart.library.html) "package:kaiteki/auth/oauth_web.dart";

String _getExtraKey(BackendType type, String host) =>
    "oAuthExtra_${type.name}_$host";

Future<void> pushExtra(
  SharedPreferences preferences,
  BackendType type,
  String host,
  Map<String, String> extra,
) async {
  final key = _getExtraKey(type, host);
  final json = jsonEncode(extra);

  await preferences.setString(key, json);
}

Uri? getRedirectUri(BackendType type, String host) {
  final baseUri = getBaseUri();

  if (baseUri == null) return null;

  final pathSegments = ["oauth", type.name, host];

  return baseUri.replace(pathSegments: pathSegments);
}

Map<String, String>? popExtra(
  SharedPreferences preferences,
  BackendType type,
  String host,
) {
  final key = _getExtraKey(type, host);

  final json = preferences.getString(key);
  if (json == null) return null;

  final map = Map<String, String>.from(jsonDecode(json));

  preferences.remove(key);

  return map;
}

/// Fetches the OAuth landing page as well as injects the app's current theme.
Future<String> generateLandingPage(ColorScheme? colorScheme) async {
  final html = await rootBundle.loadString("assets/oauth-success.html");
  const cssPlaceholder = "/* INSERT */";

  if (colorScheme == null) return html.replaceAll(cssPlaceholder, "");

  final cssBuffer = StringBuffer(":root{")
    ..writeAll(
      {
        "background": colorScheme.surface,
        "foreground": colorScheme.onSurface,
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
