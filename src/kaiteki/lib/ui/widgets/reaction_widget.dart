import 'package:flutter/material.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/api/adapters/interfaces/reaction_support.dart';
import 'package:kaiteki/model/fediverse/emoji.dart';
import 'package:kaiteki/model/fediverse/post.dart';
import 'package:kaiteki/model/fediverse/reaction.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

// TODO: maybe make this UI-only and remove interaction between adapters and
//       models?
class ReactionWidget extends StatefulWidget {
  final Post parentPost;
  final Reaction reaction;

  ReactionWidget({Key key, @required this.parentPost, @required this.reaction}) : super(key: key);

  @override
  _ReactionWidgetState createState() => _ReactionWidgetState();
}

class _ReactionWidgetState extends State<ReactionWidget> {
  @override
  Widget build(BuildContext context) {
    var textPadding = const EdgeInsets.only(top: 4, bottom: 4, left: 6, right: 2);

    return Card(
      child: InkWell(
        onTap: () async {
          var container = Provider.of<AccountContainer>(context);
          var reactiveAdapter = container.adapter as ReactionSupport;
          await reactiveAdapter.react(widget.parentPost, widget.reaction.emoji);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: textPadding,
              child: getEmojiWidget(context, widget.reaction.emoji),
            ),
            Padding(
              padding: textPadding.flipped,
              child: Opacity(
                opacity: 0.75,
                child: Text(widget.reaction.count.toString())
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getEmojiWidget(BuildContext context, Emoji emoji) {
    var size = 24.0;

    if (emoji is CustomEmoji) {
      var customEmoji = emoji;

      if (!customEmoji.url.endsWith(".svg")) {
        return Image.network(
          customEmoji.url,
          width: size,
          height: size,
          loadingBuilder: (c, w, e) {
            if (e == null)
              return w;

            return Icon(Mdi.emoticonOutline, size: size);
          },
        );
      }
    }

    if (emoji is UnicodeEmoji) {
      return Text(emoji.source, style: TextStyle(fontSize: size));
    }

    return Text(emoji.name, style: TextStyle(fontSize: size));
  }
}