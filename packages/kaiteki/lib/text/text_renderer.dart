import "package:collection/collection.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart" hide Element;
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/text/elements.dart";
import "package:kaiteki/text/parsers.dart";
import "package:kaiteki/theming/text_theme.dart";
import "package:kaiteki/ui/text/unblur_on_hover.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki/utils/helpers.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:logging/logging.dart";
import "package:url_launcher/url_launcher.dart";

import "../ui/text/emoji_span.dart";
import "text_context.dart";

Iterable<Element> parseText(
  String text, [
  Set<TextParser> parsers = const {SocialTextParser()},
]) {
  if (parsers.isEmpty) {
    throw ArgumentError.value(parsers, "parsers", "set cannot be empty");
  }

  Iterable<Element>? elements;

  for (final parser in parsers) {
    elements = elements == null //
        ? parser.parse(text)
        : elements.parseWith(parser);
  }

  return elements!;
}

typedef RegExpMatchElementBuilder = List<Element> Function(
  RegExpMatch match,
  String text,
);

class TextRenderer {
  static final _logger = Logger("TextRenderer");

  final TextStyle? textStyle;
  final KaitekiTextTheme? textTheme;
  final Function(UserReference reference)? onUserClick;
  final Function(Uri uri)? onLinkClick;
  final Function(String hashtag)? onHashtagClick;
  final TextContext? context;
  final bool screenReaderQuirk;

  const TextRenderer({
    this.textStyle,
    this.textTheme,
    this.onUserClick,
    this.onLinkClick,
    this.onHashtagClick,
    this.context,
    this.screenReaderQuirk = false,
  });

  factory TextRenderer.fromContext(
    BuildContext context,
    WidgetRef ref, [
    TextContext? textContext,
  ]) {
    final textTheme =
        Theme.of(context).ktkTextTheme ?? DefaultKaitekiTextTheme(context);
    return TextRenderer(
      textStyle: DefaultTextStyle.of(context).style,
      textTheme: ref.watch(underlineLinks).value
          ? textTheme.copyWith(
              linkTextStyle: textTheme.linkTextStyle
                  ?.copyWith(decoration: TextDecoration.underline),
              mentionTextStyle: textTheme.mentionTextStyle
                  ?.copyWith(decoration: TextDecoration.underline),
              hashtagTextStyle: textTheme.hashtagTextStyle
                  ?.copyWith(decoration: TextDecoration.underline),
            )
          : textTheme,
      onUserClick: (reference) => resolveAndOpenUser(reference, context, ref),
      onLinkClick: (url) async {
        await launchUrl(
          url,
          mode: ref.read(preferredUrlLaunchMode),
        );
      },
      onHashtagClick: (hashtag) {
        context.pushNamed(
          "hashtag",
          pathParameters: {...ref.accountRouterParams, "hashtag": hashtag},
        );
      },
      context: textContext,
      screenReaderQuirk: MediaQuery.accessibleNavigationOf(context),
    );
  }

  InlineSpan render(Iterable<Element>? elements) {
    return TextSpan(children: renderChildren(elements).toList());
  }

  Iterable<InlineSpan> renderChildren(Iterable<Element>? children) sync* {
    if (children == null) return;

    for (final child in children) {
      final element = _renderElement(child);
      if (element != null) yield element;
    }
  }

  InlineSpan renderEmoji(EmojiElement element) {
    final name = element.name;
    final emoji = context?.emojiResolver?.call(name);

    if (emoji == null) return TextSpan(text: ":$name:");

    return EmojiSpan(
      emoji,
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
    final onClick = onHashtagClick;

    // TalkBack will break apart the text if there's inline hashtags/recognizers.
    if (onClick == null || screenReaderQuirk) {
      return TextSpan(text: "#${hashtag.name}");
    }

    final textStyle = textTheme?.linkTextStyle;
    final color = textStyle?.color?.withOpacity(.65);
    final recognizer = TapGestureRecognizer()
      ..onTap = () => onClick(hashtag.name);

    return TextSpan(
      children: [
        TextSpan(
          text: "#",
          style: TextStyle(color: color),
          recognizer: recognizer,
        ),
        TextSpan(
          text: hashtag.name,
          recognizer: recognizer,
        ),
      ],
      style: textStyle,
      recognizer: recognizer,
    );
  }

  TextSpan renderLink(LinkElement link) {
    final onClick = onLinkClick;

    final children = renderChildren(link.children).toList();

    if (onClick == null) return TextSpan(children: children);

    if (children.isEmpty) _logger.warning("Link has no children");

    // FIXME(Craftplacer): We should be passing down the "click-ability" to the children.
    final recognizer = TapGestureRecognizer()
      ..onTap = () => onClick(link.destination);
    final childrenWithRecognizers =
        children.map((e) => _overrideGestureDetector(e, recognizer)).toList();
    return TextSpan(
      recognizer: recognizer,
      style: textTheme?.linkTextStyle,
      children: childrenWithRecognizers,
    );
  }

  InlineSpan _overrideGestureDetector(
    InlineSpan span,
    TapGestureRecognizer recognizer,
  ) {
    if (span is TextSpan) {
      return TextSpan(
        recognizer: recognizer,
        style: span.style,
        children: span.children
            ?.map((e) => _overrideGestureDetector(e, recognizer))
            .toList(),
        text: span.text,
      );
    } else {
      return span;
    }
  }

  InlineSpan? renderMention(MentionElement element) {
    final reference =
        context?.users.firstWhereOrNull(element.reference.matches) ??
            element.reference;

    final isExcluded = context?.excludedUsers.any(reference.matches);
    if (isExcluded == true) return null;

    final onClick = onUserClick;

    if (onClick == null) {
      return TextSpan(text: reference.toString());
    } else {
      return TextSpan(
        recognizer: TapGestureRecognizer()..onTap = () => onClick(reference),
        text: reference.toString(),
        style: textTheme?.mentionTextStyle,
      );
    }
  }

  InlineSpan? _renderElement(Element element) {
    return switch (element) {
      TextStyleElement() => renderTextStyle(element),
      TextElement() => TextSpan(text: element.text),
      LinkElement() => renderLink(element),
      HashtagElement() => renderHashtag(element),
      MentionElement() => renderMention(element),
      EmojiElement() => renderEmoji(element),
      _ => renderFallbackSpan(element)
    };
  }

  InlineSpan renderTextStyle(TextStyleElement element) {
    final children = renderChildren(element.children);

    double? getFontSize(double? fontSize, double? scale) =>
        fontSize == null || scale == null ? null : fontSize * scale;

    final style = TextStyle(
      backgroundColor: element.style.background,
      color: element.style.foreground,
      fontWeight: element.style.bold == true ? FontWeight.bold : null,
      fontStyle: element.style.italic == true ? FontStyle.italic : null,
      fontSize: getFontSize(textStyle?.fontSize, element.style.scale),
    );

    final textSpan = TextSpan(style: style, children: children.toList());

    if (element.style.blur == true) {
      return WidgetSpan(
        child: UnblurOnHover(child: Text.rich(textSpan)),
      );
    }

    return textSpan;
  }
}
