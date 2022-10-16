import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/preview_card.dart';
import 'package:kaiteki/utils/extensions/build_context.dart';
import 'package:kaiteki/utils/extensions/string.dart';

class CardWidget extends StatelessWidget {
  final PreviewCard card;

  const CardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: 2,
      color: theme.cardColor,
      child: InkWell(
        onTap: () => context.launchUrl(card.link),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (card.imageUrl.isNotNullOrEmpty)
              Image.network(
                card.imageUrl!,
                width: 120,
              ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(card.title, style: theme.textTheme.headline6),
                    if (card.description != null) Text(card.description!),
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
