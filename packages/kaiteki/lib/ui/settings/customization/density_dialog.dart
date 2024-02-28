import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/common.dart";

import "density_list_tile.dart";

class DensityDialog extends StatefulWidget {
  final VisualDensity? visualDensity;

  const DensityDialog({super.key, this.visualDensity});

  @override
  State<DensityDialog> createState() => _DensityDialogState();
}

class _DensityDialogState extends State<DensityDialog> {
  late VisualDensity? visualDensity;

  @override
  void initState() {
    super.initState();
    visualDensity = widget.visualDensity;
  }

  @override
  Widget build(BuildContext context) {
    const densities = [
      VisualDensity.standard,
      VisualDensity.comfortable,
      VisualDensity.compact,
    ];

    return AlertDialog(
      title: const Text("Density"),
      contentPadding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile(
            title: const Text("System"),
            subtitle: Text(
              getNameForDensity(VisualDensity.adaptivePlatformDensity) ??
                  VisualDensity.adaptivePlatformDensity.toString(),
            ),
            groupValue: visualDensity,
            value: null,
            onChanged: (value) => setState(() => visualDensity = value),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          ),
          const Divider(),
          for (final density in densities)
            RadioListTile(
              title: Text(getNameForDensity(density) ?? density.toString()),
              groupValue: visualDensity,
              value: density,
              onChanged: (value) => setState(() => visualDensity = value),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            ),
        ],
      ),
      actions: [
        const CancelTextButton(),
        TextButton(
          onPressed: () {
            final visualDensity = this.visualDensity;
            return Navigator.of(context).pop(
              visualDensity == null
                  ? const SystemDensityDialogResult()
                  : CustomDensityDialogResult(visualDensity),
            );
          },
          child: Text(context.materialL10n.okButtonLabel),
        ),
      ],
    );
  }
}

sealed class DensityDialogResult {
  const DensityDialogResult();
}

class SystemDensityDialogResult extends DensityDialogResult {
  const SystemDensityDialogResult();
}

class CustomDensityDialogResult extends DensityDialogResult {
  final VisualDensity visualDensity;

  const CustomDensityDialogResult(this.visualDensity);
}
