// ignore_for_file: avoid_web_libraries_in_flutter

import "dart:html" as html;
import "dart:js" as js;
import "dart:ui_web" as ui_web show urlStrategy, HashUrlStrategy;

import "package:kaiteki/auth/oauth.dart" as common;
import "package:kaiteki_core/social.dart";

bool? get isProtocolHandlerRegistered {
  final value = js.context["isProtocolHandlerRegistered"];
  if (value is bool) return value;
  return null;
}

Future<Map<String, String>?> runServer(
  OAuthUrlCreatedCallback ready,
  String successPage,
) async {
  throw UnsupportedError("runServer is not supported on the web");
}

Uri? getBaseUri() {
  // We cannot read the query parameters if we're using the hash strategy.
  if (!_isUsingHashUrlStrategy) {
    // get base tag from head
    final base = html.document.head?.querySelector("base")?.attributes["href"];
    final current = Uri.tryParse(html.window.location.href);
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

  if (_isUsingHashUrlStrategy) {
    return baseUri.replace(fragment: '/${pathSegments.join('/')}');
  }

  return common.getRedirectUri(type, host);
}
