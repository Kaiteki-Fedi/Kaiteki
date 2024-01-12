import "package:flutter/material.dart";

class AttachBottomSheet extends StatelessWidget {
  final VoidCallback? onPickFile;
  final VoidCallback? onPickMedia;
  final VoidCallback? onAddPoll;

  const AttachBottomSheet({
    super.key,
    this.onPickFile,
    this.onPickMedia,
    this.onAddPoll,
  });

  @override
  Widget build(BuildContext context) {
    final onPickMedia = this.onPickMedia;
    final onPickFile = this.onPickFile;
    final onAddPoll = this.onAddPoll;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              "Attach",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Row(
            children: [
              if (onPickMedia != null)
                Expanded(
                  child: _AttachButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onPickMedia();
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("Media"),
                  ),
                ),
              if (onPickFile != null)
                Expanded(
                  child: _AttachButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onPickFile();
                    },
                    icon: const Icon(Icons.insert_drive_file),
                    label: const Text("File"),
                  ),
                ),
              if (onAddPoll != null)
                Expanded(
                  child: _AttachButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onAddPoll();
                    },
                    icon: const Icon(Icons.poll),
                    label: const Text("Poll"),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AttachButton extends StatelessWidget {
  const _AttachButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTheme.merge(
            data: const IconThemeData(size: 48.0),
            child: icon,
          ),
          const SizedBox(height: 8.0),
          DefaultTextStyle.merge(
            textAlign: TextAlign.center,
            child: label,
          ),
        ],
      ),
    );
  }
}
