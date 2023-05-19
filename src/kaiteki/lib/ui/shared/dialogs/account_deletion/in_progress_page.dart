import "package:flutter/material.dart";
import "package:kaiteki/ui/shared/common.dart";

class AccountDeletionInProgressPage extends StatelessWidget {
  const AccountDeletionInProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        circularProgressIndicator,
        SizedBox(width: 16.0),
        Text("Deleting account..."),
      ],
    );
  }
}
