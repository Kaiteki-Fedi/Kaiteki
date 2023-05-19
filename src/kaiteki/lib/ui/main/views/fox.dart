import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/services/notifications.dart";
import "package:kaiteki/ui/main/pages/notifications.dart";
import "package:kaiteki/ui/main/views/view.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/ui/shared/posts/compose/compose_form.dart";
import "package:kaiteki/utils/extensions.dart";

class FoxMainScreenView extends ConsumerStatefulWidget
    implements MainScreenView {
  final Widget Function(TabKind tab) getPage;
  final TabKind tab;
  final Function(TabKind tab) onChangeTab;
  final Function(MainScreenViewType view) onChangeView;

  const FoxMainScreenView({
    super.key,
    required this.getPage,
    required this.onChangeTab,
    required this.tab,
    required this.onChangeView,
  });

  @override
  ConsumerState<FoxMainScreenView> createState() => _FoxMainScreenViewState();
}

class _FoxMainScreenViewState extends ConsumerState<FoxMainScreenView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(49),
        child: Material(
          elevation: 4.0,
          child: SizedBox(
            height: 49,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 980),
                child: Row(
                  children: [
                    const SizedBox(width: 24),
                    Text("${ref.watch(accountProvider)?.key.host}"),
                    const Spacer(),
                    Row(
                      children: [
                        const IconButton(
                          icon: Icon(Icons.search),
                          onPressed: null,
                        ),
                        const IconButton(
                          icon: Icon(Icons.settings),
                          onPressed: null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.exit_to_app_rounded),
                          onPressed: () {
                            widget.onChangeView(MainScreenViewType.stream);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 365,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    children: [
                      FocusTraversalGroup(child: const _UserPanel()),
                      const SizedBox(height: 16),
                      FocusTraversalGroup(
                        child: _NavigationPanel(
                          tab: widget.tab,
                          onChangeTab: widget.onChangeTab,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FocusTraversalGroup(child: _NotificationPanel()),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              FocusTraversalGroup(
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Card(
                      child: widget.getPage(widget.tab),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationPanel extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);
    final notificationService = notificationServiceProvider(account!.key);
    final notifications = ref.watch(notificationService).valueOrNull;

    return Card(
      child: Column(
        children: [
          AppBar(
            title: const Text("Notifications"),
            forceMaterialTransparency: true,
          ),
          if (notifications != null)
            for (final notification in notifications)
              NotificationWidget(notification),
        ],
      ),
    );
  }
}

class _UserPanel extends ConsumerStatefulWidget {
  const _UserPanel();

  @override
  ConsumerState<_UserPanel> createState() => _UserPanelState();
}

class _UserPanelState extends ConsumerState<_UserPanel> {
  final composeFormKey = GlobalKey<ComposeFormState>();

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(accountProvider)!;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () => context.showUser(account.user, ref),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x80000000), Colors.transparent],
                      ).createShader(
                        Rect.fromLTRB(0, 0, rect.width, rect.height),
                      );
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.network(
                      account.user.bannerUrl?.toString() ?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          AvatarWidget(
                            account.user,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  account.user.renderDisplayName(context, ref),
                                ),
                                Text(
                                  "@${account.user.username}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ComposeForm(
            key: composeFormKey,
            onSubmit: () => composeFormKey.currentState?.reset(),
          ),
        ],
      ),
    );
  }
}

class _NavigationPanel extends StatelessWidget {
  final TabKind tab;
  final Function(TabKind tab) onChangeTab;

  const _NavigationPanel({
    required this.tab,
    required this.onChangeTab,
  });

  @override
  Widget build(BuildContext context) {
    final destinations = [
      (
        Icons.view_headline_rounded,
        "Timelines",
        TabKind.home,
      ),
      (
        Icons.forum_rounded,
        "Chats",
        TabKind.chats,
      ),
    ];

    final tileTextStyle = Theme.of(context).textTheme.bodyLarge;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (final (icon, title, tab) in destinations)
            ListTile(
              leading: Icon(icon),
              title: Text(title),
              onTap: () => onChangeTab(tab),
              titleTextStyle: tab == this.tab
                  ? tileTextStyle?.copyWith(fontWeight: FontWeight.bold)
                  : tileTextStyle,
              tileColor: tab == this.tab
                  ? Theme.of(context).colorScheme.surfaceVariant
                  : null,
            ),
        ],
      ),
    );
  }
}
