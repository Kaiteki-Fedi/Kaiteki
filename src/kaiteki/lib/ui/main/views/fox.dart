import "package:flutter/material.dart";
import "package:kaiteki/ui/main/pages/timeline.dart";
import "package:kaiteki/ui/main/views/view.dart";
import "package:kaiteki/ui/shared/posts/compose/compose_form.dart";

class FoxMainScreenView extends StatefulWidget implements MainScreenView {
  const FoxMainScreenView({super.key});

  @override
  State<FoxMainScreenView> createState() => _FoxMainScreenViewState();

  @override
  NavigationVisibility get navigationVisibility => NavigationVisibility.hide;
}

class _FoxMainScreenViewState extends State<FoxMainScreenView> {
  final composeFormKey = GlobalKey<ComposeFormState>();
  @override
  Widget build(BuildContext context) {
    return Center(
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
                        onSubmit: () => composeFormKey.currentState?.reset(),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              FocusTraversalGroup(
                child: const Expanded(child: Card(child: TimelinePage())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
