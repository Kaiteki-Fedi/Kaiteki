import "package:flutter/material.dart";
import "package:kaiteki/utils/extensions.dart";

class CrashScreen extends StatelessWidget {
  final Object exception;
  final StackTrace? stackTrace;

  const CrashScreen({super.key, required this.exception, this.stackTrace});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sentiment_very_dissatisfied_rounded,
              size: 64,
            ),
            const SizedBox(height: 8),
            Text(
              "Kaiteki crashed.",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(exception.toString()),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                context.showExceptionDialog(exception, stackTrace);
              },
              child: const Text("Show details"),
            ),
          ],
        ),
      ),
    );
  }
}
