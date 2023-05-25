import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/model/post/post.dart";
import "package:kaiteki/ui/shared/dialogs/dialog_close_button.dart";
import "package:kaiteki/ui/shared/posts/compose/compose_form.dart";
import "package:kaiteki/ui/shared/posts/compose/discard_post_dialog.dart";
import "package:kaiteki/ui/shared/posts/compose/toggle_subject_button.dart";
import "package:kaiteki/ui/window_class.dart";
import "package:kaiteki/utils/extensions.dart";

class ComposeScreen extends ConsumerStatefulWidget {
  final Post? replyTo;

  const ComposeScreen({super.key, this.replyTo});

  @override
  ConsumerState<ComposeScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<ComposeScreen> {
  bool enableSubject = false;
  bool showPreview = false;
  final key = GlobalKey<ComposeFormState>();

  @override
  Widget build(BuildContext context) {
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
      child: WindowClass.fromContext(context) > WindowClass.compact
          ? Dialog(
              child: buildBody(context, false),
            )
          : Dialog.fullscreen(
              child: buildBody(context, true),
            ),
    );
  }

  Column buildBody(BuildContext context, bool fullscreen) {
    final l10n = context.l10n;
    final adapter = ref.watch(adapterProvider);
    final replyTo = widget.replyTo;
    TextSpan? replyTextSpan;

    if (replyTo != null) {
      replyTextSpan = TextSpan(
        text: l10n.composeDialogTitleReply,
        children: [replyTo.author.renderDisplayName(context, ref)],
      );
    }

    final closeButton = (ModalRoute.of(context)?.canPop ?? false)
        ? DialogCloseButton(tooltip: l10n.discardButtonTooltip)
        : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          actions: [
            if (adapter.capabilities.supportsSubjects)
              ToggleSubjectButton(
                value: enableSubject,
                onChanged: showPreview ? null : toggleSubject,
              ),
            IconButton(
              isSelected: showPreview,
              onPressed: togglePreview,
              icon: const Icon(Icons.preview_rounded),
              tooltip: "Toggle preview",
              // HACK(Craftplacer): `AppBar`s break the selected color in `IconButton`s, https://github.com/flutter/flutter/issues/127626
              selectedIcon: Icon(
                Icons.preview_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            if (!fullscreen && closeButton != null) closeButton,
          ],
          automaticallyImplyLeading: false,
          leading: fullscreen && closeButton != null ? closeButton : null,
          title: replyTextSpan == null
              ? Text(l10n.composeDialogTitle)
              : Text.rich(replyTextSpan),
          forceMaterialTransparency: true,
        ),
        const Divider(),
        Expanded(
          flex: fullscreen ? 1 : 0,
          child: ComposeForm(
            key: key,
            enableSubject: enableSubject,
            showPreview: showPreview,
            expands: fullscreen,
            replyTo: widget.replyTo,
            onSubmit: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }

  void toggleSubject() => setState(() => enableSubject = !enableSubject);
  void togglePreview() => setState(() => showPreview = !showPreview);
}
