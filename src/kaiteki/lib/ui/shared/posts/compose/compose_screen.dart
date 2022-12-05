import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/interfaces/preview_support.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/ui/shared/dialogs/dialog_close_button.dart';
import 'package:kaiteki/ui/shared/dialogs/dynamic_dialog_container.dart';
import 'package:kaiteki/ui/shared/posts/compose/discard_post_dialog.dart';
import 'package:kaiteki/ui/shared/posts/compose/post_form.dart';
import 'package:kaiteki/ui/shared/posts/compose/toggle_subject_button.dart';
import 'package:kaiteki/utils/extensions.dart';

class ComposeScreen extends ConsumerStatefulWidget {
  final Post? replyTo;

  const ComposeScreen({super.key, this.replyTo});

  @override
  ConsumerState<ComposeScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<ComposeScreen> {
  bool enableSubject = false;
  bool showPreview = false;
  final key = GlobalKey<PostFormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();
    final adapter = ref.watch(adapterProvider);
    final replyTo = widget.replyTo;

    return WillPopScope(
      onWillPop: () async {
        if (key.currentState?.isEmpty == false) {
          final dialogResult = await showDialog(
            context: context,
            builder: (_) => const DiscardPostDialog(),
          );
          return dialogResult == true;
        }

        return true;
      },
      child: DynamicDialogContainer(
        builder: (context, fullscreen) {
          TextSpan? replyTextSpan;

          if (replyTo != null) {
            replyTextSpan = TextSpan(
              text: l10n.composeDialogTitleReply,
              children: [replyTo.author.renderDisplayName(context, ref)],
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                actions: [
                  if (adapter is PreviewSupport)
                    IconButton(
                      isSelected: showPreview,
                      onPressed: togglePreview,
                      icon: const Icon(Icons.preview_rounded),
                    ),
                  if (adapter.capabilities.supportsSubjects)
                    ToggleSubjectButton(
                      value: enableSubject,
                      onChanged: toggleSubject,
                    ),
                  if (!fullscreen)
                    DialogCloseButton(tooltip: l10n.discardButtonTooltip),
                ],
                automaticallyImplyLeading: false,
                leading: fullscreen
                    ? DialogCloseButton(tooltip: l10n.discardButtonTooltip)
                    : null,
                foregroundColor: Theme.of(context).colorScheme.onBackground,
                title: replyTextSpan == null
                    ? Text(l10n.composeDialogTitle)
                    : Text.rich(replyTextSpan),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              Expanded(
                flex: fullscreen ? 1 : 0,
                child: PostForm(
                  key: key,
                  enableSubject: enableSubject,
                  showPreview: showPreview,
                  expands: fullscreen,
                  replyTo: widget.replyTo,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void toggleSubject() => setState(() => enableSubject = !enableSubject);
  void togglePreview() => setState(() => showPreview = !showPreview);
}
