import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/ui/shared/dialogs/dialog_close_button.dart';
import 'package:kaiteki/ui/shared/dialogs/dynamic_dialog_container.dart';
import 'package:kaiteki/ui/shared/posts/compose/discard_post_dialog.dart';
import 'package:kaiteki/ui/shared/posts/compose/post_form.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:mdi/mdi.dart';

class ComposeScreen extends ConsumerStatefulWidget {
  final Post? replyTo;

  const ComposeScreen({Key? key, this.replyTo}) : super(key: key);

  @override
  ConsumerState<ComposeScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<ComposeScreen> {
  bool enableSubject = false;
  final key = GlobalKey<PostFormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();
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
              children: [replyTo.author.renderDisplayName(context)],
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                actions: [
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
}

class ToggleSubjectButton extends StatelessWidget {
  const ToggleSubjectButton({
    Key? key,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  final bool value;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = value ? theme.colorScheme.primary : null;

    return IconButton(
      onPressed: onChanged,
      icon: const Icon(Mdi.textShort),
      tooltip: _getTooltip(),
      color: color,
    );
  }

  String _getTooltip() {
    return "${value ? "Disable" : "Enable"} Subject";
  }
}
