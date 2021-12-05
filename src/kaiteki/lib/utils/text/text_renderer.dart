import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/fediverse/model/emoji.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/logger.dart';
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
  final List<User>? users;
  final List<Emoji>? emojis;

  TextContext({this.users, this.emojis});
}

class TextRenderer {
  final TextParser parser = HtmlTextParser();

  static const String emojiChar = ":";
  static final _logger = getLogger("TextRenderer");

  final TextRendererTheme theme;

  TextRenderer({required this.theme});

  InlineSpan render(
    BuildContext context,
    String text, {
    TextContext? textContext,
  }) {
    textContext ?? TextContext();

    final elements = parser
        .parse(text)
        .parseWith(SocialTextParser())
        .parseWith(MfmTextParser());

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
    } else if (element is LinkElement) {
      // FIXME: We should be passing down the "click-ability" to the children.

      final recognizer = TapGestureRecognizer()
        ..onTap = () => context.launchUrl(element.destination.toString());

      return TextSpan(
        style: theme.linkTextStyle,
        recognizer: recognizer,
        text: childrenSpans!.isNotEmpty
            ? (childrenSpans!.first as TextSpan).text!
            : null,
      );
    } else if (element is MentionElement) {
      final userIndex = textContext.users?.indexWhere((user) {
            return user.username == element.username;
          }) ??
          -1;
      final user = userIndex == -1 ? null : textContext.users![userIndex];

      return WidgetSpan(
        child: UserChip(id: user?.id ?? "", user: user),
      );
    }

    if (element is Element && element.children?.isNotEmpty == true) {
      return TextSpan(children: childrenSpans);
    } else {
      return TextSpan(
        text: "[NIY ${element.runtimeType}]",
        style: const TextStyle(
          backgroundColor: Colors.red,
          color: Colors.white,
        ),
      );
      throw StateError("");
    }
  }
}

extension TextElementExtension on TextElement {
  TextStyle getFlutterTextStyle(BuildContext context) {
    final style = this.style;

    if (style == null) {
      return const TextStyle();
    }

    final inheritedSize = DefaultTextStyle.of(context).style.fontSize!;

    return TextStyle(
      fontWeight: style.bold == true ? FontWeight.bold : null,
      fontStyle: style.italic == true ? FontStyle.italic : null,
      fontSize: style.scale != 1.0 ? (inheritedSize * style.scale) : null,
    );
  }
}

class UserChip extends StatelessWidget {
  final String id;
  final User? user;

  const UserChip({Key? key, required this.id, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<AccountManager>(context);
    return FutureBuilder(
        initialData: user,
        future: manager.adapter.getUserById(id),
        builder: (context, AsyncSnapshot<User> snapshot) {
          final user = snapshot.data;

          return ActionChip(
            avatar: user != null
                ? AvatarWidget(
                    user,
                    size: 24,
                  )
                : null,
            label: user != null
                ? Text.rich(user.renderDisplayName(context))
                : Text(id),
            onPressed: () {},
          );
        });
  }
}
