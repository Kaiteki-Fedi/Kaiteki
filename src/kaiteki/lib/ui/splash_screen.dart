import "package:flutter/material.dart";
import "package:kaiteki/model/startup_state.dart";

class SplashScreen extends StatelessWidget {
  final Stream<StartupState> stream;

  const SplashScreen({super.key, required this.stream});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/icon.png",
              width: 64,
              height: 64,
            ),
            const SizedBox(height: 32),
            StreamBuilder<StartupState>(
              stream: stream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                final message = switch (state) {
                  StartupSignIn() => "Signing into ${state.accountKey.host}...",
                  _ => "Loading...",
                };

                return Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
