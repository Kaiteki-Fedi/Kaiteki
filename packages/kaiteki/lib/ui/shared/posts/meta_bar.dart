import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:fpdart/fpdart.dart";
import "package:intl/intl.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/theming/text_theme.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/post_scope_icon.dart";
import "package:kaiteki/ui/shared/posts/post_widget_theme.dart";
import "package:kaiteki/ui/shared/posts/user_badge.dart";
import "package:kaiteki/ui/shared/users/user_display_name_widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki/utils/pronouns.dart";
import "package:kaiteki_core/kaiteki_core.dart";

const _kPronounsFieldKeys = [
  "pronouns",
  "pronomen",
];

class MetaBar extends ConsumerWidget {
  const MetaBar({
    super.key,
    required Post post,
    this.twolineAuthor = false,
    this.onOpen,
    this.showTime,
    this.showVisibility,
    this.showLanguage,
  }) : _post = post;

  final Post _post;
  final bool twolineAuthor;
  final bool? showTime;
  final bool? showVisibility;
  final bool? showLanguage;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final author = _post.author;

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
                child: UserDisplayNameWidget(
                  author,
                  orientation: twolineAuthor ? Axis.vertical : Axis.horizontal,
                  trailing: buildLeft(context, ref)
                      .intersperse(const SizedBox(width: 8))
                      .toList(),
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
    final theme = Theme.of(context);
    final author = _post.author;
    final isAdministrator = author.flags?.isAdministrator ?? false;
    final isModerator = author.flags?.isModerator ?? false;
    final isBot = author.type == UserType.bot;

    if (ref.watch(highlightPronouns).value) {
      final pronouns = author.details.fields
          ?.firstWhereOrNull(
              (e) => _kPronounsFieldKeys.contains(e.key.trim().toLowerCase()),)
          ?.value
          .andThen(parsePronouns);
      if (pronouns != null && pronouns.isNotEmpty) {
        var colors; //_getColorsForPronoun(pronouns[0][0]);
        colors = colors
            ?.map((e) => e.harmonizeWith(theme.colorScheme.primary))
            .toList();
        yield PronounBadge(
          pronouns: pronouns,
          colors: colors,
        );
      }
    }

    if (ref.watch(showUserBadges).value) {
      if (isAdministrator) {
        yield const UserBadge(type: UserBadgeType.administrator);
      } else if (isModerator) {
        yield const UserBadge(type: UserBadgeType.moderator);
      }

      if (isBot) {
        yield const UserBadge(type: UserBadgeType.bot);
      }
    }
  }

  Widget buildRight(BuildContext context) {
    final scope = _post.visibility;
    final l10n = context.l10n;

    final theme = Theme.of(context);
    final postTheme = PostWidgetTheme.of(context);

    final language = _post.language;

    final showLanguage = this.showLanguage ?? postTheme?.showLanguage ?? true;
    final showTime = this.showTime ?? postTheme?.showTime ?? true;
    final showScope = showVisibility ?? postTheme?.showVisibility ?? true;

    return DefaultTextStyle.merge(
      style: theme.textTheme.labelMedium,
      child: ContentColor(
        color: theme.colorScheme.onSurfaceVariant,
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
                child: PostTimestamp(_post.postedAt.toLocal()),
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
      ),
    );
  }
}

class PronounBadge extends StatelessWidget {
  final List<Color>? colors;
  final List<List<String>> pronouns;

  const PronounBadge({
    super.key,
    this.colors,
    required this.pronouns,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = this.colors;
    final hasColors = colors != null && colors.isNotEmpty;
    final textStyle = theme.textTheme.labelSmall;
    final color = hasColors ? Colors.white : textStyle?.color;

    var text = pronouns[0][0];
    if (pronouns.length > 1) text += "+";

    return Tooltip(
      message: "Pronouns: ${pronouns.map((e) => e.join("/")).join(", ")}",
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: hasColors
              ? LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: hasColors ? null : theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadii.extraSmall,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2.0, 2.0, 4.0, 2.0),
          child: Row(
            children: [
              Icon(Icons.loyalty_rounded, size: 16, color: color),
              const SizedBox(width: 4),
              DefaultTextStyle.merge(
                child: Text(text),
                style: textStyle?.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostTimestamp extends StatelessWidget {
  const PostTimestamp(this.dateTime, {super.key});

  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    final text = DateFormat.yMMMMd(
      Localizations.localeOf(context).toString(),
    ).add_jm().format(dateTime);

    final relativeTime = DateTime.now().difference(dateTime);
    return Semantics(
      label: relativeTime.toLongString(),
      excludeSemantics: true,
      child: Tooltip(
        message: text,
        child: Text(relativeTime.toStringHuman(context: context)),
      ),
    );
  }
}

class _Language extends ConsumerWidget {
  const _Language({
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
