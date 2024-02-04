import "package:flutter/material.dart";
import "package:kaiteki_core/model.dart";
import "package:url_launcher/url_launcher.dart";

class EmbedWidget extends StatelessWidget {
  final Embed embed;

  const EmbedWidget(this.embed, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final description = embed.description;
    return Card.outlined(
      child: InkWell(
        onTap: () => launchUrl(embed.uri),
        child: SizedBox(
          height: 8 * 12,
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (embed.title != null)
                        Text(
                          embed.title!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                      if (description != null && description.isNotEmpty)
                        Text(
                          description
                              .split("\n")
                              .where((e) => e.isNotEmpty)
                              .join(" "),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIcon(BuildContext context) {
    if (embed.imageUrl == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            Icons.public_rounded,
            size: 32,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Image.network(
      embed.imageUrl!.toString(),
      width: 120,
      fit: BoxFit.cover,
    );
  }
}
