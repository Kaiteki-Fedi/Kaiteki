import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/theming/kaiteki/text_theme.dart';
import 'package:kaiteki/ui/stack_trace_screen.dart';
import 'package:tuple/tuple.dart';
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

  Map<String, Tuple2<String, bool>> get longDetails {
    return {
      if (stackTrace != null)
        "Stack Trace": Tuple2(
          stackTrace.toString(),
          false,
        ),
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
              ListTile(
                title: Text(detail.key),
                subtitle: Text(detail.value),
                contentPadding: EdgeInsets.zero,
              ),
            const Divider(height: 17),
            ListTile(
              title: const Text("Show stack trace"),
              leading: const Icon(Icons.segment_rounded),
              enabled: stackTrace != null,
              onTap: () {
                final stackTrace = this.stackTrace;
                if (stackTrace == null) return;
                showDialog(
                  context: context,
                  builder: (_) => StackTraceScreen(stackTrace: stackTrace),
                );
              },
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              title: const Text("Report on GitHub"),
              leading: const Icon(Icons.error_rounded),
              onTap: onReportIssue,
              contentPadding: EdgeInsets.zero,
            ),
            for (var detail in longDetails.entries)
              if (detail.value.item2)
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  title: Text(detail.key),
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SelectableText(
                        detail.value.item1,
                        style:
                            Theme.of(context).ktkTextTheme?.monospaceTextStyle,
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
          child: const Text('Close'),
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
