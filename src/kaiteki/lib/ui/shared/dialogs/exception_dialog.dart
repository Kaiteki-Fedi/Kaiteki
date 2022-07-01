import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/exceptions/json_deserialization_error.dart';
import 'package:kaiteki/utils/utils.dart';
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
      "Runtime Type": exception.runtimeType.toString(),
      "Text": exception.toString(),
    };
  }

  Map<String, String> get longDetails {
    return {
      if (exception is JsonDeserializationError)
        "JSON": (exception as JsonDeserializationError).json,
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
                      style: GoogleFonts.robotoMono(),
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

    await launchUrl(
      Uri.https(
        "github.com",
        "/Kaiteki-Fedi/Kaiteki/issues/new",
        {
          "title": _tryGetTitle() ?? "Exception in Kaiteki",
          "body": bodyBuffer.toString(),
          "labels": "bug",
        },
      ),
      mode: LaunchMode.externalApplication,
    );
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
        Flexible(child: SelectableText(value, style: GoogleFonts.robotoMono())),
      ],
    );
  }
}
