import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/main/pages/timeline.dart";
import "package:kaiteki/ui/main/views/view.dart";
import "package:kaiteki/ui/shared/posts/compose/compose_form.dart";

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
  final composeFormKey = GlobalKey<ComposeFormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Material(
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
                      const Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.search),
                            onPressed: null,
                          ),
                          IconButton(
                            icon: Icon(Icons.settings),
                            onPressed: null,
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
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 980),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FocusTraversalGroup(
                        child: SizedBox(
                          width: 365,
                          child: SingleChildScrollView(
                            child: Card(
                              child: ComposeForm(
                                key: composeFormKey,
                                onSubmit: () =>
                                    composeFormKey.currentState?.reset(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      FocusTraversalGroup(
                        child:
                            const Expanded(child: Card(child: TimelinePage())),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
