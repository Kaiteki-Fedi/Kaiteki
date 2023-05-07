import "package:flutter/material.dart";
import "package:kaiteki/fediverse/model/embed.dart";
import "package:url_launcher/url_launcher.dart";

class EmbedWidget extends StatelessWidget {
  final Embed embed;

  const EmbedWidget(this.embed, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: () => launchUrl(embed.uri),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: buildIcon(context),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DefaultTextStyle.merge(
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (embed.title != null)
                          Text(
                            embed.title!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        if (embed.description != null) Text(embed.description!),

                        Text(
                          embed.uri.host,
                          style: TextStyle(
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIcon(BuildContext context) {
    if (embed.largeImageUrl == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            Icons.public_rounded,
            size: 32,
            color: Theme.of(context).disabledColor,
          ),
        ),
      );
    }

    return Image.network(
      embed.largeImageUrl!,
      width: 120,
      fit: BoxFit.cover,
    );
  }
}
