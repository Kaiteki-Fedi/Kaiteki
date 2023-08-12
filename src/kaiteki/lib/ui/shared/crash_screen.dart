import "package:flutter/material.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/utils.dart";

class CrashScreen extends StatelessWidget {
  final TraceableError error;

  const CrashScreen(this.error, {super.key});

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
            Text(error.$1.toString()),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.showExceptionDialog(error),
              child: const Text("Show details"),
            ),
          ],
        ),
      ),
    );
  }
}
