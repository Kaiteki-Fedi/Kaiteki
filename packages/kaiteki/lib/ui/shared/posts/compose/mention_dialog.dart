import "package:flutter/material.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/dialogs/find_user_dialog.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki_core/model.dart";

class MentionListDialog extends StatefulWidget {
  final String? originalPoster;
  final List<String> mentioned;
  final List<String> inThisConversation;

  const MentionListDialog({
    super.key,
    required this.originalPoster,
    required this.mentioned,
    required this.inThisConversation,
  });

  @override
  State<MentionListDialog> createState() => _MentionListDialogState();
}

class _MentionListDialogState extends State<MentionListDialog> {
  late List<String> _manuallyMentioned;
  late List<String> _alsoMentioned;

  @override
  void initState() {
    super.initState();

    _alsoMentioned = widget.inThisConversation
        .where((e) => widget.mentioned.contains(e))
        .toList();

    _manuallyMentioned = widget.mentioned
        .where((e) => !widget.inThisConversation.contains(e))
        .toList();
  }

  List<String> get mentions => [..._alsoMentioned, ..._manuallyMentioned];

  @override
  Widget build(BuildContext context) {
    const divider = Divider(indent: 24.0, endIndent: 24.0, height: 1 + 8.0 * 2);
    const listTileContentPadding = EdgeInsets.only(left: 24.0, right: 16.0);
    const subheadingPadding = EdgeInsets.symmetric(horizontal: 24.0);
    final originalPoster = widget.originalPoster;
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (originalPoster != null)
          CheckboxListTile(
            secondary: AvatarWidget(null, size: 40.0),
            contentPadding: listTileContentPadding,
            title: Text(originalPoster),
            subtitle: const Text("The replied to user is always mentioned"),
            value: true,
            onChanged: null,
          ),
        if (!(originalPoster == null || widget.inThisConversation.isEmpty))
          divider,
        if (widget.inThisConversation.isNotEmpty) ...[
          const Subheader(
            Text("Also in this conversation"),
            padding: subheadingPadding,
          ),
          for (final mention in widget.inThisConversation)
            CheckboxListTile(
              contentPadding: listTileContentPadding,
              secondary: AvatarWidget(null, size: 40.0),
              title: Text(mention),
              value: _alsoMentioned.contains(mention),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _alsoMentioned.add(mention);
                  } else {
                    _alsoMentioned.remove(mention);
                  }
                });
              },
            ),
        ],
        if (!(originalPoster == null || widget.inThisConversation.isEmpty))
          divider,
        const Subheader(
          Text("Mentioned by you"),
          padding: subheadingPadding,
        ),
        for (final mention in _manuallyMentioned)
          ListTile(
            contentPadding: listTileContentPadding.copyWith(right: 12.0),
            leading: AvatarWidget(null, size: 40.0),
            title: Text(mention),
            trailing: IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => setState(
                () => _manuallyMentioned.remove(mention),
              ),
              tooltip: "Remove",
            ),
          ),
        // divider,
        ListTile(
          leading: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.alternate_email_rounded),
          ),
          contentPadding: listTileContentPadding,
          title: const Text("Mention someone else"),
          onTap: _onMention,
        ),
      ],
    );

    final okButton = TextButton(
      onPressed: () => Navigator.of(context).pop(mentions),
      child: Text(context.materialL10n.okButtonLabel),
    );

    const title = Text("Mentions");
    if (WindowWidthSizeClass.fromContext(context) <=
        WindowWidthSizeClass.compact) {
      return Scaffold(
        appBar: AppBar(
          title: title,
          actions: [okButton],
        ),
        body: body,
      );
    }

    return AlertDialog(
      actions: [const CancelTextButton(), okButton],
      contentPadding: const EdgeInsets.only(bottom: 8.0),
      title: title,
      content: ConstrainedBox(
        constraints: kDialogConstraints,
        child: body,
      ),
      scrollable: true,
    );
  }

  Future<void> _onMention() async {
    final user = await showDialog<User>(
      context: context,
      builder: (_) => const FindUserDialog(),
    );

    if (user == null) return;

    setState(() => _manuallyMentioned.add(user.handle.toString()));
  }
}
