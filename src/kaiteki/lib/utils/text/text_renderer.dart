import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/fediverse/model/emoji.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/fediverse/model/user_reference.dart';
import 'package:kaiteki/ui/screens/account_screen.dart';
import 'package:kaiteki/ui/widgets/emoji/emoji_widget.dart';
import 'package:kaiteki/ui/widgets/posts/avatar_widget.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:kaiteki/utils/text/elements.dart';
import 'package:kaiteki/utils/text/parsers.dart';
import 'package:kaiteki/utils/text/text_renderer_theme.dart';
import 'package:provider/provider.dart';

typedef RegExpMatchElementBuilder = Element Function(
  RegExpMatch match,
  String text,
);

class TextContext {
  final List<UserReference>? users;
  final List<Emoji>? emojis;

  TextContext({this.users, this.emojis});
}

class TextRenderer {
  // TODO: Use appropiate parser on specific instances
  final TextParser parser = MastodonHtmlTextParser();
  final TextRendererTheme theme;

  TextRenderer({required this.theme});

  InlineSpan render(
    BuildContext context,
    String text, {
    TextContext? textContext,
  }) {
    textContext ?? TextContext();

    final elements = parser.parse(text).parseWith(SocialTextParser());

    final renderedElements = elements.map((e) {
      return _renderElement(context, e, textContext!);
    });

    return TextSpan(children: renderedElements.toList(growable: false));
  }

  InlineSpan _renderElement(
    BuildContext context,
    Element element,
    TextContext textContext,
  ) {
    final childrenSpans = element.children //
        ?.map((e) => _renderElement(context, e, textContext))
        .toList(growable: false);

    if (element is TextElement) {
      return renderText(context, element, childrenSpans);
    } else if (element is LinkElement) {
      return renderLink(context, element, childrenSpans!);
    } else if (element is HashtagElement) {
      return renderHashtag(context, textContext, element);
    } else if (element is MentionElement) {
      return renderMention(textContext, element);
    } else if (element is EmojiElement) {
      return renderEmoji(textContext, element);
    }

    if (element.children?.isNotEmpty == true) {
      return TextSpan(children: childrenSpans);
    }

    return TextSpan(
      text: "[NIY ${element.runtimeType}]",
      style: const TextStyle(
        backgroundColor: Colors.red,
        color: Colors.white,
      ),
    );
  }

  InlineSpan renderText(
    BuildContext context,
    TextElement element,
    List<InlineSpan>? childrenSpans,
  ) {
    InlineSpan span = TextSpan(
      text: element.text,
      style: element.getFlutterTextStyle(context),
      children: childrenSpans,
    );

    if (element.style?.blur == true) {
      return WidgetSpan(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: 8.0,
            sigmaY: 8.0,
          ),
          child: Text(element.text!),
        ),
      );
    }

    return span;
  }

  WidgetSpan renderMention(TextContext textContext, MentionElement element) {
    final i = textContext.users?.indexWhere(
          (user) => user.matches(element.reference),
        ) ??
        -1;
    final reference = i == -1 ? element.reference : textContext.users![i];

    return WidgetSpan(
      child: UserChip(reference: reference),
      baseline: TextBaseline.alphabetic,
      alignment: PlaceholderAlignment.middle,
    );
  }

  TextSpan renderHashtag(
    BuildContext context,
    TextContext textContext,
    HashtagElement element,
  ) {
    final color = DefaultTextStyle.of(context).style.color!.withOpacity(.35);
    return TextSpan(
      children: [
        TextSpan(text: '#', style: TextStyle(color: color)),
        TextSpan(text: element.name),
      ],
    );
  }

  TextSpan renderLink(
    BuildContext context,
    LinkElement link,
    List<InlineSpan> children,
  ) {
    // FIXME: We should be passing down the "click-ability" to the children.

    final recognizer = TapGestureRecognizer()
      ..onTap = () => context.launchUrl(link.destination.toString());

    return TextSpan(
      style: theme.linkTextStyle,
      recognizer: recognizer,
      text: link.allText,
    );
  }

  InlineSpan renderEmoji(
    TextContext textContext,
    EmojiElement element,
  ) {
    final emoji = textContext.emojis!.firstOrDefault((e) {
      return e.name == element.name;
    });

    if (emoji == null) {
      return TextSpan(text: element.name);
    }

    return WidgetSpan(
      child: EmojiWidget(emoji: emoji, size: theme.emojiSize),
      baseline: TextBaseline.alphabetic,
      alignment: PlaceholderAlignment.middle,
    );
  }
}

extension TextElementExtension on TextElement {
  TextStyle getFlutterTextStyle(BuildContext context) {
    final style = this.style;

    if (style == null) {
      return const TextStyle();
    }

    final inheritedSize = DefaultTextStyle.of(context).style.fontSize;

    return TextStyle(
      fontWeight: style.bold == true ? FontWeight.bold : null,
      fontStyle: style.italic == true ? FontStyle.italic : null,
      fontSize: style.scale != 1.0 ? (inheritedSize! * style.scale) : null,
    );
  }
}

class UserChip extends StatelessWidget {
  final UserReference reference;
  final User? user;

  const UserChip({
    Key? key,
    required this.reference,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adapter = Provider.of<AccountManager>(context).adapter;
    return FutureBuilder(
      initialData: user,
      future: reference.resolve(adapter),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data!;

          return Tooltip(
            message: getHandle(user),
            child: ActionChip(
              avatar: AvatarWidget(user, size: 24),
              label: Text.rich(user.renderDisplayName(context)),
              onPressed: () {
                var screen = AccountScreen.fromUser(user);
                var route = MaterialPageRoute(builder: (_) => screen);
                Navigator.push(context, route);
              },
            ),
          );
        } else {
          return const Chip(
            avatar: Icon(Icons.help),
            label: Text("Unknown User"),
          );
        }
      },
    );
  }

  String getHandle(User user) {
    if (user.host == null) {
      return '@${user.username}';
    } else {
      return '@${user.username}@${user.host}';
    }
  }
}
