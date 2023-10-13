import "dart:async";
import "dart:io";

import "package:async/async.dart";
import "package:kaiteki_core/social.dart";
import "package:shelf/shelf.dart";
import "package:shelf/shelf_io.dart";

bool? get isProtocolHandlerRegistered => Platform.isAndroid;

Uri? getBaseUri() {
  if (isProtocolHandlerRegistered == true) {
    // HACK(Craftplacer): https://github.com/flutter/flutter/issues/124045
    return Uri(scheme: "web+kaitekisocial", host: "go-router-is-poop");
  }

  return null;
}

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
