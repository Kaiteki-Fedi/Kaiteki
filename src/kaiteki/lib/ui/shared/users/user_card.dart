import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/text/rendering_extensions.dart";
import "package:kaiteki_core/social.dart";
import "package:kaiteki_core/utils.dart";

class UserCard extends ConsumerWidget {
  /// The user to display. If null, a placeholder will be displayed.
  final User? user;

  final List<Widget> actions;

  const UserCard(this.user, {super.key, this.actions = const []});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final handleTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
    final displayNameTextStyle =
        Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            );
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: user?.bannerUrl.nullTransform(
                (url) => Image.network(
                  url.toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            user?.renderDisplayName(context, ref) ??
                                const TextSpan(text: "..."),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: displayNameTextStyle,
                          ),
                          Text(
                            user?.handle.toString() ?? "...",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: handleTextStyle,
                          ),
                        ],
                      ),
                    ),
                    ...actions,
                  ],
                ),
                const SizedBox(height: 8),
                if (user?.description != null)
                  Text.rich(
                    user?.renderDescription(context, ref) ??
                        const TextSpan(
                          text: "...",
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
