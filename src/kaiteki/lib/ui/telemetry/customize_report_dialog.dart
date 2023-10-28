import "package:flutter/material.dart";
import "package:kaiteki/app.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/telemetry/report.dart";

class CustomizeReportDialog extends ConsumerStatefulWidget {
  final ExceptionReport report;

  const CustomizeReportDialog(this.report, {super.key});

  @override
  ConsumerState<CustomizeReportDialog> createState() =>
      _CustomizeReportDialogState();
}

class _CustomizeReportDialogState extends ConsumerState<CustomizeReportDialog> {
  bool _includePlatform = true;
  bool _includeBackend = true;
  bool _includeResponse = true;

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = EdgeInsets.symmetric(horizontal: 24.0);
    final json = widget.report.json;

    const versionName = KaitekiApp.versionName;
    const versionCode = KaitekiApp.versionCode;

    const versionAvailable = !(versionName == null || versionCode == null);
    final platform = widget.report.platform;
    final backend = widget.report.backend;
    return AlertDialog(
      contentPadding: const EdgeInsets.only(top: 16, bottom: 24.0),
      title: const Text("Customize report"),
      content: ConstrainedBox(
        constraints: kDialogConstraints,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: horizontalPadding,
              child: Text(
                "Take a moment to take a look at the data collected for your bug report. You can remove any data you don't want to be included.",
              ),
            ),
            const SizedBox(height: 16),
            const CheckboxListTile(
              contentPadding: horizontalPadding,
              title: Text("App version"),
              // ignore: avoid_redundant_argument_values, cannot be determined at compile time
              subtitle: versionAvailable
                  // ignore: l10n
                  ? Text("$versionName ($versionCode)")
                  : null,
              value: versionAvailable,
              onChanged: null,
            ),
            CheckboxListTile(
              contentPadding: horizontalPadding,
              title: const Text("Exception information (with stack trace)"),
              // ignore: l10n
              subtitle: Text("${widget.report.type}: ${widget.report.body}"),
              value: true,
              onChanged: null,
              isThreeLine: true,
            ),
            if (platform != null)
              CheckboxListTile(
                contentPadding: horizontalPadding,
                title: const Text("Platform information"),
                subtitle: Text(platform),
                value: _includePlatform,
                onChanged: (value) => setState(() => _includePlatform = value!),
                isThreeLine: true,
              ),
            if (backend != null)
              CheckboxListTile(
                contentPadding: horizontalPadding,
                title: const Text("Backend information"),
                subtitle: Text(backend.toString()),
                value: _includeBackend,
                onChanged: (value) => setState(() => _includeBackend = value!),
                isThreeLine: true,
              ),
            if (json != null)
              CheckboxListTile(
                contentPadding: horizontalPadding,
                title: const Text("API response"),
                subtitle: Text(json.replaceAll("\n", "")),
                value: _includeResponse,
                onChanged: (value) => setState(() => _includeResponse = value!),
                isThreeLine: true,
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.materialL10n.cancelButtonLabel),
        ),
        TextButton(
          onPressed: _onSubmit,
          child: Text(context.l10n.submitButtonTooltip),
        ),
      ],
    );
  }

  void _onSubmit() {
    final report = widget.report.redact(
      redactPlatform: !_includePlatform,
      redactJson: !_includeResponse,
      redactBackend: !_includeBackend,
    );

    Navigator.of(context).pop(report);
  }
}
