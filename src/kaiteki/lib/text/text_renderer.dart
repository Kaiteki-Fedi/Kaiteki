import "package:collection/collection.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart" hide Element;
import "package:kaiteki/di.dart";
import "package:kaiteki/text/elements.dart";
import "package:kaiteki/text/parsers.dart";
import "package:kaiteki/text/unblur_on_hover.dart";
import "package:kaiteki/theming/kaiteki/text_theme.dart";
import "package:kaiteki/ui/shared/emoji/emoji_theme.dart";
import "package:kaiteki/ui/shared/emoji/emoji_widget.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki/utils/helpers.dart";
import "package:kaiteki_core/model.dart";
import "package:kaiteki_core/utils.dart";
import "package:url_launcher/url_launcher.dart";

List<Element> parseText(
  String text, [
  Set<TextParser> parsers = const {SocialTextParser()},
]) {
  if (parsers.isEmpty) {
    throw ArgumentError.value(parsers, "parsers", "set cannot be empty");
  }

  List<Element>? elements;

  for (final parser in parsers) {
    if (elements == null) {
      elements = parser.parse(text);
      continue;
    }

    elements = elements.parseWith(parser);
  }

  return elements!;
}

typedef EmojiResolver = Emoji? Function(String name);

typedef RegExpMatchElementBuilder = Element Function(
  RegExpMatch match,
  String text,
);

class TextContext {
  final List<UserReference> users;
  final List<UserReference> excludedUsers;
  final EmojiResolver? emojiResolver;

  const TextContext({
    this.users = const [],
    this.emojiResolver,
    this.excludedUsers = const [],
  });
}

class TextRenderer {
  final TextStyle? textStyle;
  final KaitekiTextTheme? textTheme;
  final Function(UserReference reference)? onUserClick;
  final Function(Uri uri)? onLinkClick;
  final TextContext? context;

  const TextRenderer({
    this.textStyle,
    this.textTheme,
    this.onUserClick,
    this.onLinkClick,
    this.context,
  });

  factory TextRenderer.fromContext(
    BuildContext context,
    WidgetRef ref, [
    TextContext? textContext,
  ]) {
    return TextRenderer(
      textStyle: DefaultTextStyle.of(context).style,
      textTheme:
          Theme.of(context).ktkTextTheme ?? DefaultKaitekiTextTheme(context),
      onUserClick: (reference) => resolveAndOpenUser(reference, context, ref),
      onLinkClick: (url) async {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      },
      context: textContext,
    );
  }

  InlineSpan render(List<Element>? elements) {
    return TextSpan(children: renderChildren(elements));
  }

  List<InlineSpan> renderChildren(List<Element>? children) {
    if (children == null) return const [];

    final spans = <InlineSpan>[];

    for (final child in children) {
      final element = _renderElement(child);
      if (element != null) spans.add(element);
    }

    return spans;
  }

  InlineSpan renderEmoji(EmojiElement element) {
    final name = element.name;
    final emoji = context?.emojiResolver?.call(name);

    if (emoji == null) return TextSpan(text: ":$name:");

    // FIXME(Craftplacer): Change this piece widget into an EmojiSpan. Added Builder to fix scaling with inherited font size.
    return WidgetSpan(
      child: TextInheritedEmojiTheme(child: EmojiWidget(emoji)),
      baseline: TextBaseline.alphabetic,
      alignment: PlaceholderAlignment.middle,
    );
  }

  InlineSpan renderFallbackSpan(Element element) {
    return TextSpan(
      text: "[NIY ${element.runtimeType}]",
      style: const TextStyle(
        backgroundColor: Colors.red,
        color: Colors.white,
      ),
    );
  }

  TextSpan renderHashtag(HashtagElement hashtag) {
    final textStyle = textTheme?.linkTextStyle;
    final color = textStyle?.color?.withOpacity(.65);
    return TextSpan(
      children: [
        TextSpan(text: "#", style: TextStyle(color: color)),
        TextSpan(text: hashtag.name),
      ],
      style: textStyle,
    );
  }

  TextSpan renderLink(LinkElement link) {
    // FIXME(Craftplacer): We should be passing down the "click-ability" to the children.
    return TextSpan(
      recognizer: onLinkClick.nullTransform(
        (onClick) =>
            TapGestureRecognizer()..onTap = () => onClick(link.destination),
      ),
      text: link.allText,
      style: textTheme?.linkTextStyle,
    );
  }

  InlineSpan? renderMention(MentionElement element) {
    final reference =
        context?.users.firstWhereOrNull(element.reference.matches) ??
            element.reference;

    final isExcluded = context?.excludedUsers.any(reference.matches);
    if (isExcluded == true) return null;

    const useUserChip = false;

    // ignore: dead_code
    if (useUserChip) {
      return WidgetSpan(
        child: UserChip(reference: reference),
        baseline: TextBaseline.alphabetic,
        alignment: PlaceholderAlignment.middle,
      );
    } else {
      return TextSpan(
        recognizer: onUserClick.nullTransform(
          (onTap) => TapGestureRecognizer()..onTap = () => onTap(reference),
        ),
        text: reference.toString(),
        style: textTheme?.mentionTextStyle,
      );
    }
  }

  InlineSpan renderText(TextElement element, List<InlineSpan>? children) {
    double? getFontSize(double? fontSize, double? scale) =>
        fontSize == null || scale == null ? null : fontSize * scale;

    TextStyle? getTextStyle(TextElementStyle? style) {
      if (style == null) return null;
      return TextStyle(
        fontWeight: style.bold == true ? FontWeight.bold : null,
        fontStyle: style.italic == true ? FontStyle.italic : null,
        fontSize: getFontSize(textStyle?.fontSize, style.scale),
      );
    }

    final span = TextSpan(
      text: element.text,
      style: getTextStyle(element.style),
      children: children,
    );

    if (element.style?.blur == true) {
      return WidgetSpan(
        child: UnblurOnHover(child: Text.rich(span)),
      );
    }

    return span;
  }

  InlineSpan? _renderElement(Element element) {
    final children = renderChildren(element.children);

    return switch (element) {
      TextElement() => renderText(element, children),
      LinkElement() => renderLink(element),
      HashtagElement() => renderHashtag(element),
      MentionElement() => renderMention(element),
      EmojiElement() => renderEmoji(element),
      _ => children.isNotEmpty == true
          ? TextSpan(children: children)
          : renderFallbackSpan(element)
    };
  }
}

class UserChip extends ConsumerWidget {
  final UserReference reference;
  final User? user;

  const UserChip({
    super.key,
    required this.reference,
    this.user,
  });

  String get fallbackText {
    if (reference.username != null) {
      return reference.host != null
          ? "@${reference.username}@${reference.host}"
          : "@${reference.username}";
    }

    if (reference.remoteUrl != null) {
      return reference.remoteUrl!;
    }

    return "Unknown User";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adapter = ref.watch(adapterProvider);
    return FutureBuilder<User?>(
      initialData: user,
      future: reference.resolve(adapter),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data!;

          return Tooltip(
            message: user.handle.toString(),
            child: ActionChip(
              avatar: AvatarWidget(user, size: 24),
              label: Text.rich(user.renderDisplayName(context, ref)),
              onPressed: () => context.showUser(user, ref),
            ),
          );
        } else {
          return Chip(label: Text(fallbackText));
        }
      },
    );
  }
}
