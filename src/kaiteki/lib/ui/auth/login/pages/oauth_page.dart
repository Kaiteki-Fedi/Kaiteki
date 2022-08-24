import 'package:flutter/material.dart';
import 'package:kaiteki/ui/shared/icon_landing_widget.dart';

class OAuthPage extends StatelessWidget {
  final VoidCallback? onCancel;

  const OAuthPage({this.onCancel, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const IconLandingWidget(
            icon: Icon(Icons.key_rounded),
            text: Text("Waiting for OAuth to finish..."),
          ),
          if (onCancel != null) ...[
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onCancel,
              child: const Text("Cancel"),
            ),
          ],
        ],
      ),
    );
  }
}
