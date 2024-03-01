import "package:flutter/material.dart";
import "package:kaiteki/ui/shared/common.dart";
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
          height: 8 * 13,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                ),
                child: SizedBox(
                  width: 128,
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
                          style: theme.textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      if (description != null && description.isNotEmpty)
                        Text(
                          description
                              .split("\n")
                              .where((e) => e.isNotEmpty)
                              .join(" "),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                      Text(
                        embed.uri.host,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ].spacedVertically(8.0),
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
    final fallback = Center(
      child: Icon(
        Icons.public_rounded,
        size: 32,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );

    if (embed.imageUrl == null) {
      return fallback;
    }

    return Image.network(
      embed.imageUrl!.toString(),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}
