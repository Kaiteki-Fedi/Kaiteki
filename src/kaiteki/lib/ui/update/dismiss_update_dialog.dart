import 'package:flutter/material.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/di.dart';

class DismissUpdateDialog extends StatefulWidget {
  const DismissUpdateDialog({super.key});

  @override
  State<DismissUpdateDialog> createState() => _DismissUpdateDialogState();
}

class _DismissUpdateDialogState extends State<DismissUpdateDialog> {
  bool _notify = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Dismiss update?"),
      content: ConstrainedBox(
        constraints: dialogConstraints,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "If you dismiss this update, you won't be notified again until you restart Kaiteki, unless you choose to disable checking for updates completely.",
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              value: _notify,
              onChanged: (value) => setState(() => _notify = value!),
              title: const Text("Don't notify about updates again"),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.materialL10n.cancelButtonLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_notify),
          child: Text(context.materialL10n.modalBarrierDismissLabel),
        ),
      ],
    );
  }
}
