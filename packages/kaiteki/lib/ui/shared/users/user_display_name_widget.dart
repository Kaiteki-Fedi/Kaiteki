import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki/utils/name_merging.dart";
import "package:kaiteki_core/social.dart";

class UserDisplayNameWidget extends ConsumerStatefulWidget {
  final User user;
  final List<Widget> trailing;
  final Axis orientation;

  const UserDisplayNameWidget(
    this.user, {
    super.key,
    this.orientation = Axis.horizontal,
    this.trailing = const [],
  });

  @override
  ConsumerState<UserDisplayNameWidget> createState() =>
      _UserDisplayNameWidgetState();
}

class _UserDisplayNameWidgetState extends ConsumerState<UserDisplayNameWidget> {
  late String _semanticsLabel;
  late String _primaryText;
  late String _secondaryText;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateText();
  }

  @override
  void didUpdateWidget(UserDisplayNameWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.user != widget.user ||
        oldWidget.orientation != widget.orientation) {
      updateText();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryTextStyle = theme.textTheme.titleSmall;
    final secondaryTextStyle = theme.textTheme.bodyMedium;

    final user = this.widget.user;
    final trailing = this.widget.trailing;

    const trailingSeparator = SizedBox(width: 4.0);
    final Widget widget = switch (this.widget.orientation) {
      Axis.horizontal => Row(
          children: [
            RepaintBoundary(
              child: Text.rich(
                TextSpan(
                  children: [
                    user.renderText(context, ref, _primaryText),
                    const TextSpan(text: " "),
                    TextSpan(
                      text: _secondaryText,
                      style: secondaryTextStyle,
                    ),
                  ],
                  style: primaryTextStyle,
                ),
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
            ),
            if (trailing.isNotEmpty) ...[
              trailingSeparator,
              ...trailing,
            ],
          ],
        ),
      Axis.vertical => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                RepaintBoundary(
                  child: Text.rich(
                    user.renderText(context, ref, _primaryText),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: primaryTextStyle,
                  ),
                ),
                if (trailing.isNotEmpty) ...[
                  trailingSeparator,
                  ...trailing,
                ],
              ],
            ),
            Text(
              _secondaryText,
              style: secondaryTextStyle,
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
          ],
        )
    };

    return Semantics(
      label: _semanticsLabel,
      excludeSemantics: true,
      child: widget,
    );
  }

  void updateText() {
    MergedName? text;

    if (widget.orientation == Axis.horizontal) {
      text = mergeNameOfUser(widget.user);
    }

    final displayName = widget.user.displayName;
    final isDisplayEmpty = displayName?.trim().isNotEmpty != true;

    _primaryText =
        text?.$1 ?? (isDisplayEmpty ? widget.user.username : displayName!);
    _secondaryText = text?.$2 ?? widget.user.handle.toString();

    _semanticsLabel = ref.watch(readDisplayNameOnly).value
        ? _primaryText
        : [_primaryText, _secondaryText].join("\n");
  }
}
