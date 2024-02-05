import "dart:io";

import "package:flutter/material.dart";
import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/common.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/telemetry/report.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";
import "package:kaiteki/ui/telemetry/customize_report_dialog.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/http.dart";
import "package:kaiteki_core/utils.dart";
import "package:url_launcher/url_launcher.dart";

class ErrorLandingWidget extends StatefulWidget {
  final TraceableError error;
  final VoidCallback? onRetry;

  const ErrorLandingWidget(
    this.error, {
    super.key,
    this.onRetry,
  });

  factory ErrorLandingWidget.fromAsyncSnapshot(
    AsyncSnapshot snapshot, {
    Key? key,
    VoidCallback? onRetry,
  }) {
    final error = snapshot.traceableError;

    if (error == null) throw ArgumentError("snapshot has no error", "snapshot");

    return ErrorLandingWidget(
      error,
      key: key,
      onRetry: onRetry,
    );
  }

  @override
  State<ErrorLandingWidget> createState() => _ErrorLandingWidgetState();
}

class _ErrorLandingWidgetState extends State<ErrorLandingWidget> {
  Widget getMessageWidget(BuildContext context) {
    final error = widget.error.$1;
    switch (error) {
      case UnimplementedError():
        return IconLandingWidget(
          icon: const Icon(Icons.assignment_late_rounded),
          text: Text(context.l10n.niy),
        );
      case HttpException()
          when error.statusCode == HttpStatus.internalServerError:
        return IconLandingWidget(
          icon: const Icon(Icons.error_rounded),
          text: Text(context.l10n.exceptionReasonGeneric),
        );
      case HttpException() when error.statusCode == HttpStatus.unauthorized:
        return IconLandingWidget(
          icon: const Icon(Icons.lock_rounded),
          text: Text(context.l10n.exceptionReasonUnauthorized),
        );
      case HttpException() when error.statusCode == HttpStatus.forbidden:
        return IconLandingWidget(
          icon: const Icon(Icons.report_rounded),
          text: Text(context.l10n.exceptionReasonForbidden),
        );
      case CheckedFromJsonException():
        return IconLandingWidget(
          icon: const Icon(Icons.broken_image_rounded),
          text: Text(context.l10n.exceptionReasonParseError),
        );
      default:
        return IconLandingWidget(
          icon: const Icon(Icons.error_rounded),
          text: Text(context.l10n.exceptionReasonGeneric),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageWidget = getMessageWidget(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        messageWidget,
        const SizedBox(height: 16),
        IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.onRetry != null) ...[
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(context.l10n.retryButtonLabel),
                  onPressed: widget.onRetry,
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.standard,
                    ),
                    onPressed: _onReport,
                    child: const Text("Report error"),
                  ),
                  const SizedBox(width: 8),
                  IconButton.outlined(
                    onPressed: () => context.showExceptionDialog(widget.error),
                    tooltip: context.l10n.showDetailsButtonLabel,
                    icon: const Icon(Icons.info_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _onReport() async {
    late final Account? account;

    try {
      account = ProviderScope.containerOf(context).read(currentAccountProvider);
    } catch (_) {
      account = null;
    }

    final report = ExceptionReport.fromException(
      widget.error.$1,
      stackTrace: widget.error.$2,
      backend: account == null ? null : retrieveBackendInformation(account.adapter, account.type),
    );

    final result = await showDialog<ExceptionReport>(
      context: context,
      builder: (_) => CustomizeReportDialog(report),
    );

    if (result == null) return;

    final url = result.getGitHubFormUrl();
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: "_blank",
    );
  }
}
