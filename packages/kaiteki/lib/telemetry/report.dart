import "dart:convert";
import "dart:io";

import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/app.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:kaiteki_core_backends/kaiteki_core_backends.dart";

typedef BackendInformation = (
  String? host,
  Type adapterType,
  BackendType backendType
);

class ExceptionReport {
  final String? stackTrace;
  final String? body;
  final String type;
  final String? platform;
  final String? version;
  final String? json;
  final BackendInformation? backend;

  const ExceptionReport({
    this.body,
    required this.type,
    this.stackTrace,
    this.platform,
    this.version,
    this.json,
    this.backend,
  });

  factory ExceptionReport.fromException(
    dynamic e, {
    StackTrace? stackTrace,
    BackendInformation? backend,
  }) {
    String? getBody() {
      try {
        return e.message as String?;
      } on NoSuchMethodError {
        return null;
      }
    }

    return ExceptionReport(
      body: getBody() ?? e.toString(),
      type: e.runtimeType.toString(),
      stackTrace: stackTrace?.toString(),
      platform: determinePlatform(),
      version: determineVersion(),
      json: e is CheckedFromJsonException
          ? const JsonEncoder.withIndent("  ").convert(e.map)
          : null,
      backend: backend,
    );
  }

  ExceptionReport redact({
    bool redactPlatform = false,
    bool redactVersion = false,
    bool redactJson = false,
    bool redactBackend = false,
  }) {
    return ExceptionReport(
      body: body,
      type: type,
      stackTrace: stackTrace,
      platform: redactPlatform ? null : platform,
      version: redactVersion ? null : version,
      json: redactJson ? null : json,
      backend: redactBackend ? null : backend,
    );
  }

  Uri getGitHubFormUrl() {
    final bodyBuffer = StringBuffer();

    if (platform != null) bodyBuffer.writeln("**Platform:** $platform");
    if (version != null) bodyBuffer.writeln("**Version:** $version");
    if (backend != null) bodyBuffer.writeln("**Backend:** $backend");

    return Uri.https(
      "github.com",
      "/Kaiteki-Fedi/Kaiteki/issues/new",
      {
        "template": "error_report.yml",
        "labels": "bug,needs-triage",
        "title": type,
        "message": body,
        "type": type,
        "stack": stackTrace,
        "extra": bodyBuffer.toString(),
      },
    );
  }
}

BackendInformation retrieveBackendInformation(
  BackendAdapter adapter,
  BackendType type,
) {
  final host = adapter.safeCast<DecentralizedBackendAdapter>()?.instance;
  final adapterType = adapter.runtimeType;
  return (host, adapterType, type);
}

String determinePlatform() {
  if (kIsWeb) return "web";

  return "${Platform.operatingSystem}: ${Platform.operatingSystemVersion}";
}

String? determineVersion() {
  if (KaitekiApp.versionName == null) return null;
  return "${KaitekiApp.versionName} (${KaitekiApp.versionCode})";
}
