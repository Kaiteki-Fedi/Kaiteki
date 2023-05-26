import "dart:io";

import "package:flutter/material.dart";
import "package:kaiteki/common.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/exceptions/http_exception.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";
import "package:kaiteki/utils/extensions.dart";

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

  @override
  Widget build(BuildContext context) {
    final error = this.error.$1;
    if (error is UnimplementedError) {
      return IconLandingWidget(
        icon: const Icon(Icons.assignment_late_rounded),
        text: Text(context.l10n.niy),
      );
    }

    if (error is HttpException) {
      if (error.statusCode == HttpStatus.unauthorized) {
        return const IconLandingWidget(
          icon: Icon(Icons.lock_rounded),
          text: Text("Unauthorized"),
        );
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const IconLandingWidget(
          icon: Icon(Icons.error_rounded),
          text: Text("An error occured"),
        ),
        const SizedBox(height: 16),
        IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (onRetry != null) ...[
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text("Retry"),
                  onPressed: onRetry,
                ),
                const SizedBox(height: 8),
              ],
              OutlinedButton(
                onPressed: () => context.showExceptionDialog(this.error),
                child: const Text("Show details"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
