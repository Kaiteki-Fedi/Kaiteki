import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/ui/dialogs/dynamic_dialog_container.dart';
import 'package:kaiteki/ui/forms/post_form.dart';
import 'package:kaiteki/ui/widgets/dialog_close_button.dart';
import 'package:kaiteki/utils/text/text_renderer.dart';
import 'package:kaiteki/utils/text/text_renderer_theme.dart';
import 'package:mdi/mdi.dart';

class PostScreen extends StatefulWidget {
  final Post? replyTo;

  const PostScreen({Key? key, this.replyTo}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool enableSubject = false;
  final key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DynamicDialogContainer(
      builder: (BuildContext context, bool fullscreen) {
        TextSpan? replyTextSpan;

        if (widget.replyTo != null) {
          final rendererTheme = TextRendererTheme.fromContext(context);
          final renderer = TextRenderer(
            theme: rendererTheme,
            emojis: widget.replyTo!.author.emojis,
          );

          replyTextSpan = TextSpan(
            text: l10n.composeDialogTitleReply,
            children: [
              renderer.renderFromHtml(
                context,
                widget.replyTo!.author.displayName,
              )
            ],
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
    return (value ? "Disable" : "Enable") + " Subject";
  }
}
