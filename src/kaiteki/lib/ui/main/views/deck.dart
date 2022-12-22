import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/model.dart';
import 'package:kaiteki/ui/main/pages/notifications.dart';
import 'package:kaiteki/ui/shared/timeline.dart';
import 'package:kaiteki/utils/extensions.dart';

class DeckMainScreenView extends StatefulWidget {
  const DeckMainScreenView({super.key});

  @override
  State<DeckMainScreenView> createState() => _DeckMainScreenViewState();
}

class _DeckMainScreenViewState extends State<DeckMainScreenView> {
  @override
  Widget build(BuildContext context) {
    const width = 8.0 * 40.0;
    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            SizedBox(
              width: width,
              child: TimelineDeckColumn(
                timelineKind: TimelineKind.home,
              ),
            ),
            SizedBox(width: 8),
            SizedBox(
              width: width,
              child: TimelineDeckColumn(
                timelineKind: TimelineKind.federated,
              ),
            ),
            SizedBox(width: 8),
            SizedBox(
              width: width,
              child: DeckColumn(
                icon: Icon(Icons.notifications_rounded),
                title: Text("Notifications"),
                child: NotificationsPage(),
              ),
            ),
            SizedBox(width: 8),
            AddColumnButton(),
          ],
        ),
      ),
    );
  }
}

class AddColumnButton extends StatelessWidget {
  const AddColumnButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Add column",
      child: OutlinedButton(
        onPressed: null,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
        ),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class DeckColumn extends StatelessWidget {
  final Widget child;
  final Widget icon;
  final Widget title;
  final List<Widget> actions;

  const DeckColumn({
    super.key,
    required this.child,
    required this.icon,
    required this.title,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            title: title,
            leading: icon,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          ),
          const Divider(height: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class TimelineDeckColumn extends StatelessWidget {
  final TimelineKind timelineKind;

  const TimelineDeckColumn({super.key, required this.timelineKind});

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();
    return DeckColumn(
      icon: Icon(timelineKind.getIconData()),
      title: Text(timelineKind.getDisplayName(l10n)),
      child: Timeline.kind(
        kind: timelineKind,
        maxWidth: 800,
      ),
    );
  }
}
