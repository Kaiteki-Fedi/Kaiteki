
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki_core/utils.dart";
import "package:url_launcher/url_launcher.dart";

class NowPlayingCard extends StatelessWidget {
  final String? title;
  final String? artist;
  final String? album;
  final Uri? coverArtUrl;
  final Uri? trackUrl;
  final Uri? profileUrl;

  const NowPlayingCard({
    super.key,
    required this.title,
    this.artist,
    this.album,
    this.coverArtUrl,
    this.trackUrl,
    this.profileUrl,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    final artist = this.artist;
    final album = this.album;

    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: trackUrl.andThen((url) {
          return () async {
            final mode = ProviderScope.containerOf(context).read(preferredUrlLaunchMode);
            await launchUrl(url, mode: mode);
          };
        }),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox.square(
                dimension: 72.0,
                child: _CoverArt(
                  image: coverArtUrl.andThen(
                        (url) => NetworkImage(url.toString()),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (title == null)

                      Text(
                        "No track playing right now",
                        style: theme.textTheme.labelSmall,
                      )
                    else ...[
                      Row(
                        children: [
                          const SizedBox(width: 3.0),
                          const Icon(Icons.play_arrow_rounded, size: 18),
                          Text(
                            "Now Playing",
                            style: theme.textTheme.labelSmall,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          title,
                          style: theme.textTheme.titleSmall,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (artist != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            artist,
                            style: theme.textTheme.bodyMedium,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (album != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            album,
                            style: theme.textTheme.labelMedium,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),],
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CoverArt extends StatelessWidget {
  final ImageProvider? image;

  const _CoverArt({required this.image});

  @override
  Widget build(BuildContext context) {
    final placeholder = Center(
      child: Icon(
        Icons.album_rounded,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );

    final image = this.image;

    return Card(
      clipBehavior: Clip.antiAlias,
      semanticContainer: false,
      child: image == null
          ? placeholder
          : Image(
        image: image,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;

          return child;
        },
        errorBuilder: (_, e, s) => placeholder,
        fit: BoxFit.cover,
      ),
    );
  }
}
