import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/theming/text_theme.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/post_scope_icon.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/ui/shared/posts/post_widget_theme.dart";
import "package:kaiteki/ui/shared/posts/user_badge.dart";
import "package:kaiteki/ui/shared/users/user_display_name_widget.dart";
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
            Expanded(
              child: ClipRect(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: buildLeft(context, ref).toList(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            buildRight(context),
          ],
        ),
      ),
    );
  }

  Iterable<Widget> buildLeft(BuildContext context, WidgetRef ref) sync* {
    final isAdministrator = _post.author.flags?.isAdministrator ?? false;
    final isModerator = _post.author.flags?.isModerator ?? false;
    final isBot = _post.author.type == UserType.bot;

    final postTheme = PostWidgetTheme.of(context);
    if (showAvatar ?? postTheme?.showAvatar ?? true) {
      yield Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ExcludeSemantics(
          child: AvatarWidget(_post.author, size: 40),
        ),
      );
    }

    yield Flexible(
      child: UserDisplayNameWidget(
        _post.author,
        orientation: twolineAuthor ? Axis.vertical : Axis.horizontal,
      ),
    );

    if (ref.watch(showUserBadges).value) {
      if (isAdministrator) {
        yield const SizedBox(width: 8);
        yield const UserBadge(type: UserBadgeType.administrator);
      } else if (isModerator) {
        yield const SizedBox(width: 8);
        yield const UserBadge(type: UserBadgeType.moderator);
      }

      if (isBot) {
        yield const SizedBox(width: 8);
        yield const UserBadge(type: UserBadgeType.bot);
      }
    }
  }

  Widget buildRight(BuildContext context) {
    final scope = _post.visibility;
    final l10n = context.l10n;
    final postTheme = PostWidgetTheme.of(context);

    final language = _post.language;

    final showLanguage = this.showLanguage ?? postTheme?.showLanguage ?? true;
    final showTime = this.showTime ?? postTheme?.showTime ?? true;
    final showScope = this.showVisibility ?? postTheme?.showVisibility ?? true;

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
              child: _Language(language: language),
            ),
          if (showTime)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: _Timestamp(_post.postedAt),
            ),
          if (scope != null && showScope)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Semantics(
                label: scope.toDisplayString(context.l10n),
                excludeSemantics: true,
                child: PostScopeIcon(scope, showTooltip: true),
              ),
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

class _Timestamp extends StatelessWidget {
  const _Timestamp(this.dateTime, {super.key});

  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    final relativeTime = DateTime.now().difference(dateTime);
    return Semantics(
      label: relativeTime.toLongString(),
      excludeSemantics: true,
      child: Tooltip(
        message: dateTime.toString(),
        child: Text(relativeTime.toStringHuman(context: context)),
      ),
    );
  }
}

class _Language extends ConsumerWidget {
  const _Language({
    super.key,
    required this.language,
  });

  final String language;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme =
        Theme.of(context).ktkTextTheme ?? DefaultKaitekiTextTheme(context);

    final widget = Text(
      language,
      style: textTheme.monospaceTextStyle,
    );

    final languageList = ref.watch(languageListProvider);
    return languageList.map(
      data: (data) {
        final languageName =
            data.value.firstWhereOrNull((e) => e.code == language)?.englishName;
        return Semantics(
          excludeSemantics: true,
          label: languageName,
          child: widget,
        );
      },
      loading: (_) => widget,
      error: (_) => widget,
    );
  }
}
