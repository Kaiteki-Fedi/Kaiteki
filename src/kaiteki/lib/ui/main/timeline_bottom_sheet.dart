import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/timeline_kind.dart';
import 'package:kaiteki/utils/extensions.dart';

class TimelineBottomSheet extends StatelessWidget {
  final TimelineKind selectedKind;

  const TimelineBottomSheet(this.selectedKind, {super.key});

  @override
  Widget build(BuildContext context) {
    const timelines = [
      TimelineKind.home,
      TimelineKind.local,
      TimelineKind.federated,
    ];

    return BottomSheet(
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Text(
                "Select Timeline",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            for (final kind in timelines) _buildTimelineItem(context, kind)
          ],
        );
      },
      onClosing: () {},
    );
  }

  Widget _buildTimelineItem(BuildContext context, TimelineKind kind) {
    final l10n = context.getL10n();
    final selected = selectedKind == kind;
    final description = kind.getDescription(l10n);
    return ListTile(
      leading: Icon(
        selected ? kind.icon.item2 : kind.icon.item1,
      ),
      title: Text(kind.getDisplayName(l10n)),
      subtitle: Text(description),
      selected: selected,
      // trailing: kind == TimelineKind.federated
      //     ? Row(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           SizedBox(child: VerticalDivider(), height: 24),
      //           IconButton(
      //             icon: Icon(Icons.help_outline_rounded),
      //             onPressed: () {},
      //           ),
      //         ],
      //       )
      //     : null,
      onTap: () => Navigator.of(context).pop(kind),
    );
  }
}
