import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/theming/kaiteki/text_theme.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/ui/shared/posts/post_widget_theme.dart";
import "package:kaiteki/ui/shared/users/user_badge.dart";
import "package:kaiteki/ui/shared/users/user_display_name_widget.dart";
import "package:kaiteki/ui/shared/visibility_icon.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/model.dart";

class MetaBar extends ConsumerWidget {
  const MetaBar({
    super.key,
    required Post post,
    this.twolineAuthor = false,
    this.onOpen,
    this.showTime,
    this.showVisibility,
    this.showLanguage,
    this.showAvatar,
  }) : _post = post;

  final Post _post;
  final bool twolineAuthor;
  final bool? showTime;
  final bool? showAvatar;
  final bool? showVisibility;
  final bool? showLanguage;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconTheme.merge(
      data: const IconThemeData(size: 18),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 32,
        ),
        child: Row(
          children: [
            ...buildLeft(context, ref),
            const SizedBox(width: 8),
            buildRight(context),
          ],
        ),
      ),
    );
  }

  List<Widget> buildLeft(BuildContext context, WidgetRef ref) {
    final isAdministrator = _post.author.flags?.isAdministrator ?? false;
    final isModerator = _post.author.flags?.isModerator ?? false;
    final isBot = _post.author.type == UserType.bot;

    final postTheme = PostWidgetTheme.of(context);

    return [
      if (showAvatar ?? postTheme?.showAvatar ?? true)
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: AvatarWidget(_post.author, size: 40),
        ),
      Expanded(
        child: Row(
          children: [
            Expanded(
              child: UserDisplayNameWidget(
                _post.author,
                orientation: twolineAuthor ? Axis.vertical : Axis.horizontal,
              ),
            ),
            if (ref.watch(showUserBadges).value) ...[
              if (isAdministrator) ...[
                const SizedBox(width: 8),
                const AdministratorUserBadge(),
              ],
              if (isModerator) ...[
                const SizedBox(width: 8),
                const ModeratorUserBadge(),
              ],
              if (isBot) ...[
                const SizedBox(width: 8),
                const BotUserBadge(),
              ],
            ],
          ],
        ),
      ),
    ];
  }

  Widget buildRight(BuildContext context) {
    final visibility = _post.visibility;
    final l10n = context.l10n;
    final postTheme = PostWidgetTheme.of(context);

    final relativeTime =
        DateTime.now().difference(_post.postedAt).toStringHuman(
              context: context,
            );
    final language = _post.language;

    final textTheme =
        Theme.of(context).ktkTextTheme ?? DefaultKaitekiTextTheme(context);

    final showLanguage = this.showLanguage ?? postTheme?.showLanguage ?? true;
    final showTime = this.showTime ?? postTheme?.showTime ?? true;
    final showVisibility =
        this.showVisibility ?? postTheme?.showVisibility ?? true;

    return ContentColor(
      color: Theme.of(context).getEmphasisColor(EmphasisColor.medium),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_post.state.pinned)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Tooltip(
                message: l10n.postPinned,
                child: const Icon(Icons.push_pin_rounded),
              ),
            ),
          if (language != null && showLanguage)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                language,
                style: textTheme.monospaceTextStyle,
              ),
            ),
          if (showTime)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Tooltip(
                message: _post.postedAt.toString(),
                child: Text(relativeTime),
              ),
            ),
          if (visibility != null && showVisibility)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: VisibilityIcon(visibility, showTooltip: true),
            ),
          if (onOpen == null)
            const SizedBox(width: 8)
          else
            IconButton(
              icon: const Icon(Icons.open_in_full_rounded),
              visualDensity: VisualDensity.compact,
              onPressed: onOpen,
              tooltip: "Open post",
              splashRadius: 16,
            ),
        ],
      ),
    );
  }
}
