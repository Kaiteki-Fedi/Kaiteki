import "package:flutter/material.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:url_launcher/url_launcher.dart";

class NewsListTile extends StatelessWidget {
  const NewsListTile({
    super.key,
    required this.embed,
  });

  final Embed? embed;

  @override
  Widget build(BuildContext context) {
    Widget? title, subtitle, trailing;

    final articleTitle = embed?.title;
    if (articleTitle != null) {
      title = Text(
        articleTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    final articleSummary = embed?.description;
    if (articleSummary != null) {
      subtitle = Text(
        articleSummary,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }

    final articleSiteName = embed?.siteName;
    if (articleSiteName != null) {
      trailing = Text(
        articleSiteName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return ListTile(
      contentPadding: const EdgeInsets.only(right: 16.0),
      leading: embed?.imageUrl.andThen(
            (url) => AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                url.toString(),
                fit: BoxFit.cover,
                isAntiAlias: true,
              ),
            ),
          ) ??
          const Icon(Icons.newspaper_rounded),
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: embed?.uri.andThen(
        (url) => () async {
          await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );
        },
      ),
      isThreeLine: true,
      titleAlignment: ListTileTitleAlignment.titleHeight,
    );
  }
}
