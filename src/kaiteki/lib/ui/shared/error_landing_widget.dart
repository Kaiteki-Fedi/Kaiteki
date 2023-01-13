import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";
import "package:kaiteki/utils/extensions.dart";

class ErrorLandingWidget extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;

  const ErrorLandingWidget({
    super.key,
    required this.error,
    this.stackTrace,
    this.onRetry,
  });

  ErrorLandingWidget.fromAsyncSnapshot(
    AsyncSnapshot snapshot, {
    super.key,
    this.onRetry,
  })  : error = snapshot.error!,
        stackTrace = snapshot.stackTrace;

  @override
  Widget build(BuildContext context) {
    if (error is UnimplementedError) {
      return IconLandingWidget(
        icon: const Icon(Icons.assignment_late_rounded),
        text: Text(context.l10n.niy),
      );
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
                onPressed: () => context.showExceptionDialog(error, stackTrace),
                child: const Text("Show details"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
