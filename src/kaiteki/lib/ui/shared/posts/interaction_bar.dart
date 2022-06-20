import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/theming/kaiteki_extension.dart';
import 'package:kaiteki/ui/debug/text_render_dialog.dart';
import 'package:kaiteki/ui/shared/posts/count_button.dart';
import 'package:kaiteki/utils/extensions/build_context.dart';

class InteractionBar extends StatelessWidget {
  const InteractionBar({
    Key? key,
    required Post post,
    required this.theme,
  })  : _post = post,
        super(key: key);

  final Post _post;
  final KaitekiExtension theme;

  @override
  Widget build(BuildContext context) {
    final openInBrowserAvailable = _post.externalUrl != null;
    final l10n = context.getL10n();

    // Added Material for fixing bork with Hero *shrug*
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 450,
      ),
      child: Flex(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        direction: Axis.horizontal,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Row(
              children: [
                CountButton(
                  icon: const Icon(Icons.reply_rounded),
                  count: _post.replyCount,
                  buttonOnly: true,
                  onTap: () => context.showPostDialog(replyTo: _post),
                  focusNode: FocusNode(skipTraversal: true),
                ),
              ],
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Row(
              children: [
                CountButton(
                  icon: const Icon(Icons.repeat_rounded),
                  count: _post.repeatCount,
                  active: _post.repeated,
                  activeColor: theme.repeatColor,
                  focusNode: FocusNode(skipTraversal: true),
                ),
              ],
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Row(
              children: [
                CountButton(
                  icon: const Icon(Icons.star_border_rounded),
                  count: _post.likeCount,
                  active: _post.liked,
                  activeColor: theme.favoriteColor,
                  activeIcon: const Icon(Icons.star_rounded),
                  focusNode: FocusNode(skipTraversal: true),
                ),
              ],
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.mood_rounded),
                  onPressed: null,
                  focusNode: FocusNode(skipTraversal: true),
                ),
              ],
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Row(
              children: [
                PopupMenuButton<VoidCallback>(
                  icon: const Icon(Icons.more_horiz),
                  onSelected: (callback) => callback.call(),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        enabled: openInBrowserAvailable,
                        child: ListTile(
                          title: Text(l10n.openInBrowserLabel),
                          leading: const Icon(Icons.open_in_new_rounded),
                          contentPadding: EdgeInsets.zero,
                          enabled: openInBrowserAvailable,
                        ),
                        value: () => context.launchUrl(_post.externalUrl!),
                      ),
                      if (_post.content != null)
                        PopupMenuItem(
                          child: const ListTile(
                            title: Text("Debug text rendering"),
                            leading: Icon(Icons.bug_report_rounded),
                            contentPadding: EdgeInsets.zero,
                          ),
                          value: () => showDialog(
                            context: context,
                            builder: (context) => TextRenderDialog(_post),
                          ),
                        ),
                    ];
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
