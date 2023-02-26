import "package:flutter/material.dart";

class AccountDeletionInProgressPage extends StatelessWidget {
  const AccountDeletionInProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CircularProgressIndicator(),
        SizedBox(width: 16.0),
        Text("Deleting account..."),
      ],
    );
  }
}
