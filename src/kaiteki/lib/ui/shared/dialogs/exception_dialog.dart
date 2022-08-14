import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/theming/kaiteki/text_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ExceptionDialog extends StatelessWidget {
  final dynamic exception;
  final StackTrace? stackTrace;

  const ExceptionDialog({
    super.key,
    required this.exception,
    required this.stackTrace,
  }) : assert(exception != null);

  Map<String, String> get details {
    return {
      "Runtime Type": exceptionRuntimeType,
      "Text": exception.toString(),
    };
  }

  String get exceptionRuntimeType => exception.runtimeType.toString();

  Map<String, String> get longDetails {
    return {
      if (stackTrace != null) "Stack Trace": stackTrace.toString(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Exception details'),
      content: ConstrainedBox(
        constraints: dialogConstraints,
        child: Column(
          children: [
            for (var detail in details.entries)
              _DataRow(title: detail.key, value: detail.value),
            const SizedBox(height: 8),
            for (var detail in longDetails.entries)
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: EdgeInsets.zero,
                title: Text(detail.key),
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SelectableText(
                      detail.value,
                      style: Theme.of(context).ktkTextTheme?.monospaceTextStyle,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
      scrollable: true,
      actions: [
        TextButton(
          onPressed: onReportIssue,
          child: const Text('Create GitHub Issue'),
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Future<void> onReportIssue() async {
    await launchUrl(
      generateIssueUrlForm(),
      mode: LaunchMode.externalApplication,
    );
  }

  Uri generateIssueUrlPlain() {
    final detailsBody = details.entries
        .map((kv) => "**${kv.key}:** `${kv.value}`") //
        .join("\n");

    final bodyBuffer = StringBuffer("$detailsBody\n\n");

    for (final detail in longDetails.entries) {
      bodyBuffer.write(
        """

## ${detail.key}
```
${detail.value}
```
""",
      );
    }

    return Uri.https(
      "github.com",
      "/Kaiteki-Fedi/Kaiteki/issues/new",
      {
        "title": _tryGetTitle() ?? "Exception in Kaiteki",
        "body": bodyBuffer.toString(),
        "labels": "bug",
      },
    );
  }

  Uri generateIssueUrlForm() {
    final bodyBuffer = StringBuffer() //
      ..writeln(
        "**Platform:** $_platform (`${Platform.operatingSystemVersion}`)",
      )
      ..writeln();

    return Uri.https(
      "github.com",
      "/Kaiteki-Fedi/Kaiteki/issues/new",
      {
        "title": _tryGetTitle() ?? "Exception in Kaiteki",
        "labels": "bug,needs-triage",
        "template": "error_report.yml",
        "message": exception.toString(),
        "type": exceptionRuntimeType,
        "stack": stackTrace?.toString(),
        "extra": bodyBuffer.toString(),
      },
    );
  }

  String get _platform {
    if (kIsWeb) return "Web";
    if (Platform.isAndroid) return "Android";
    if (Platform.isIOS) return "iOS";
    if (Platform.isMacOS) return "macOS";
    if (Platform.isLinux) return "Linux";
    if (Platform.isWindows) return "Windows";
    if (Platform.isFuchsia) return "Fuchsia";
    return "Unknown";
  }

  String? _tryGetTitle() {
    try {
      return exception.message;
    } on NoSuchMethodError catch (_) {
      return null;
    }
  }
}

class _DataRow extends StatelessWidget {
  final String title;
  final String value;

  const _DataRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title:",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8.0),
        Flexible(
          child: SelectableText(
            value,
            style: Theme.of(context).ktkTextTheme?.monospaceTextStyle,
          ),
        ),
      ],
    );
  }
}
