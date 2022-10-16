import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/ui/shared/icon_landing_widget.dart';
import 'package:kaiteki/utils/extensions.dart';

class ErrorLandingWidget extends StatelessWidget {
  final dynamic error;
  final dynamic stackTrace;

  const ErrorLandingWidget({
    super.key,
    required this.error,
    this.stackTrace,
  });

  ErrorLandingWidget.fromAsyncSnapshot(
    AsyncSnapshot snapshot, {
    super.key,
  })  : error = snapshot.error,
        stackTrace = snapshot.stackTrace;

  @override
  Widget build(BuildContext context) {
    if (error is UnimplementedError) {
      return IconLandingWidget(
        icon: const Icon(Icons.assignment_late_rounded),
        text: Text(context.getL10n().niy),
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
        TextButton(
          onPressed: () => context.showExceptionDialog(error, stackTrace),
          child: const Text("Show details"),
        ),
      ],
    );
  }
}
