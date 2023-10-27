import "dart:convert";

import "package:flutter/material.dart";
import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/theming/kaiteki/text_theme.dart";
import "package:kaiteki/ui/plain_text_screen.dart";
import "package:kaiteki/ui/stack_trace_screen.dart";
import "package:kaiteki_core/utils.dart";

class ExceptionDialog extends StatelessWidget {
  final TraceableError error;

  const ExceptionDialog(this.error, {super.key});

  Map<String, String> get details {
    return {
      "Runtime Type": exceptionRuntimeType,
      "Text": error.$1.toString(),
    };
  }

  String get exceptionRuntimeType => error.$1.runtimeType.toString();

  Map<String, (String, bool)> get longDetails {
    final stackTrace = error.$2;
    return {
      if (stackTrace != null)
        "Stack Trace": (
          stackTrace.toString(),
          false,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final stackTrace = error.$2;
    final json = error.$1.safeCast<CheckedFromJsonException>()?.map;
    return AlertDialog(
      title: Text(context.l10n.exceptionDialogTitle),
      content: ConstrainedBox(
        constraints: kDialogConstraints,
        child: Column(
          children: [
            for (final detail in details.entries)
              ListTile(
                leading: SizedBox(),
                title: Text(detail.key),
                subtitle: SelectableText(detail.value),
                contentPadding: EdgeInsets.zero,
              ),
            const Divider(height: 17),
            ListTile(
              title: Text(context.l10n.showStackTrace),
              leading: const Icon(Icons.segment_rounded),
              enabled: stackTrace != null,
              onTap: () {
                if (stackTrace == null) return;
                showDialog(
                  context: context,
                  builder: (_) => StackTraceScreen(stackTrace: stackTrace),
                );
              },
              contentPadding: EdgeInsets.zero,
            ),
            if (json != null)
              ListTile(
                title: Text(context.l10n.exceptionShowJson),
                leading: const Icon(Icons.data_object_rounded),
                enabled: stackTrace != null,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => PlainTextScreen(
                      const JsonEncoder.withIndent("  ").convert(json),
                      // ignore: l10n
                      title: const Text("JSON"),
                    ),
                  );
                },
                contentPadding: EdgeInsets.zero,
              ),
            for (final detail in longDetails.entries)
              if (detail.value.$2)
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  title: Text(detail.key),
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SelectableText(
                        detail.value.$1,
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
          child: Text(context.materialL10n.closeButtonLabel),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
