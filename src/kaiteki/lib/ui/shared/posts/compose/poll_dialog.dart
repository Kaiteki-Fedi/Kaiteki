import "package:flutter/material.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki_core/model.dart";

class PollDialog extends StatefulWidget {
  final Poll? poll;

  const PollDialog({super.key, this.poll});

  @override
  State<PollDialog> createState() => _PollDialogState();
}

class _PollDialogState extends State<PollDialog> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: kDialogConstraints,
      child: AlertDialog(
        title: Text(widget.poll == null ? "Add poll" : "Edit poll"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Question",
                border: OutlineInputBorder(),
              ),
            ),
            Divider(height: 17),
            TextField(
              decoration: const InputDecoration(
                labelText: "Add an option",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
