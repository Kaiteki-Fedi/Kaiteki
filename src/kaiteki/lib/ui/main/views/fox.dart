import 'package:flutter/material.dart';
import 'package:kaiteki/ui/main/pages/timeline.dart';
import 'package:kaiteki/ui/shared/posts/compose/post_form.dart';

class FoxMainScreenView extends StatelessWidget {
  const FoxMainScreenView({super.key});

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
                child: const SizedBox(
                  width: 365,
                  child: SingleChildScrollView(
                    child: Card(child: PostForm()),
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
