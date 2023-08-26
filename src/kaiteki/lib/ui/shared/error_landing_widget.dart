import "dart:io";

import "package:flutter/material.dart";
import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/common.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/http.dart";
import "package:kaiteki_core/utils.dart";

class ErrorLandingWidget extends StatelessWidget {
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

  Widget getMessageWidget(BuildContext context) {
    final error = this.error.$1;
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
              if (onRetry != null) ...[
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(context.l10n.retryButtonLabel),
                  onPressed: onRetry,
                ),
                const SizedBox(height: 8),
              ],
              OutlinedButton(
                onPressed: () => context.showExceptionDialog(error),
                child: Text(context.l10n.showDetailsButtonLabel),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
