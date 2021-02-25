import 'package:flutter/material.dart';
import 'package:kaiteki/model/fediverse/previewCard.dart';
import 'package:url_launcher/url_launcher.dart';

class CardWidget extends StatelessWidget {
  final PreviewCard card;

  const CardWidget({Key key, @required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Material(
      elevation: 2,
      color: theme.cardColor,
      child: InkWell(
        onTap: () {
          launch(card.link);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (card.imageUrl.isNotEmpty)
              Image.network(
                card.imageUrl,
                width: 120,
              ),

            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(card.title, style: theme.textTheme.headline6),
                    Text(card.description),
                    // Spacer(),
                    // Row(
                    //   children: [
                    //     if (card.pleroma.opengraph["site_name"] != null)
                    //       Text(card.pleroma.opengraph["site_name"])
                    //   ],
                    // )
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
