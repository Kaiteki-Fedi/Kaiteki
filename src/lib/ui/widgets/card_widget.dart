import 'package:flutter/material.dart';
import 'package:kaiteki/api/model/mastodon/card.dart';
import 'package:url_launcher/url_launcher.dart';

class CardWidget extends StatelessWidget {
  final MastodonCard card;

  const CardWidget({Key key, @required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Material(
      elevation: 2,
      color: theme.cardColor,
      child: InkWell(
        onTap: () {
          launch(card.url);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (card.image.isNotEmpty)
              Image.network(
                card.image,
                width: 120,
              ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Flexible(
                fit: FlexFit.loose,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(card.title, style: theme.textTheme.headline6),
                    Text(card.description),
                    Spacer(),
                    //Row(
                    //  children: [
                    //    if (card.pleroma.opengraph["site"] != null)
                    //      Text(card.pleroma.opengraph["site"])
                    //  ],
                    //)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
