import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/services/notifications.dart";
import "package:kaiteki/ui/main/pages/notifications.dart";
import "package:kaiteki/ui/main/views/view.dart";
import "package:kaiteki/ui/shared/posts/compose/compose_form.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";
import "package:kaiteki/ui/shared/timeline/source.dart";
import "package:kaiteki/ui/shared/timeline/widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:kaiteki_core/model.dart";

class DeckMainScreenView extends ConsumerStatefulWidget
    implements MainScreenView {
  final Widget Function(TabKind tab) getPage;
  final TabKind tab;
  final Function(TabKind tab) onChangeTab;
  final Function([MainScreenViewType? view]) onChangeView;

  const DeckMainScreenView({
    super.key,
    required this.getPage,
    required this.onChangeTab,
    required this.tab,
    required this.onChangeView,
  });

  @override
  ConsumerState<DeckMainScreenView> createState() => _DeckMainScreenViewState();
}

class _DeckMainScreenViewState extends ConsumerState<DeckMainScreenView> {
  @override
  Widget build(BuildContext context) {
    const width = 8.0 * 40.0;
    return Scaffold(
      body: Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: width,
                child: Column(
                  children: [
                    const Card(
                      child: ComposeForm(),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        leading: const Icon(Icons.swap_horiz_rounded),
                        title: const Text("Switch Layout"),
                        onTap: widget.onChangeView,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const SizedBox(
                width: width,
                child: TimelineDeckColumn(
                  timelineKind: TimelineType.following,
                ),
              ),
              const SizedBox(width: 8),
              const SizedBox(
                width: width,
                child: TimelineDeckColumn(
                  timelineKind: TimelineType.federated,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: width,
                child: DeckColumn(
                  icon: const Icon(Icons.notifications_rounded),
                  title: Text(context.l10n.notificationsTab),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: () {
                        final account = ref.read(currentAccountProvider)!;
                        ref
                            .read(
                              notificationServiceProvider(account.key).notifier,
                            )
                            .refresh();
                      },
                    ),
                  ],
                  child: const NotificationsPage(),
                ),
              ),
              const SizedBox(width: 8),
              const AddColumnButton(),
            ],
          ),
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
  final TimelineType timelineKind;

  const TimelineDeckColumn({super.key, required this.timelineKind});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DeckColumn(
      icon: Icon(timelineKind.getIconData()),
      title: Text(timelineKind.getDisplayName(l10n)),
      child: Timeline(
        StandardTimelineSource(timelineKind),
        maxWidth: 800,
        postLayout: PostWidgetLayout.wide,
      ),
    );
  }
}
