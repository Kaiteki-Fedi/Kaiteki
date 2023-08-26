import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/text/text_renderer.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/kaiteki_core.dart";

class PollWidget extends StatelessWidget {
  final Poll poll;
  final List<CustomEmoji> emojis;
  final EdgeInsets padding;

  const PollWidget(
    this.poll, {
    super.key,
    this.padding = EdgeInsets.zero,
    this.emojis = const [],
  });

  factory PollWidget.fromPost(
    Post post, {
    Key? key,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    final poll = post.poll;

    if (poll == null) throw ArgumentError("Post has no poll", "post");

    return PollWidget(
      post.poll!,
      key: key,
      padding: padding,
      emojis: post.emojis?.whereType<CustomEmoji>().toList() ?? [],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //final maxVotes = poll.options.map((o) => o.voteCount).max;
    final borderRadius = BorderRadius.circular(8);
    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Poll",
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              for (final option in poll.options) ...[
                const SizedBox(height: 8),
                Stack(
                  children: [
                    if (option.voteCount != null)
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(.25),
                            borderRadius: borderRadius,
                          ),
                          child: SizedBox(
                            width: constraints.maxWidth *
                                (poll.voteCount == 0
                                    ? 1
                                    : (option.voteCount! / poll.voteCount)),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer(
                            builder: (context, ref, _) {
                              return Text.rich(
                                TextRenderer.fromContext(
                                  context,
                                  ref,
                                  TextContext(
                                    // HACK(Craftplacer): this is jank
                                    emojiResolver: (e) => resolveEmoji(
                                      e,
                                      ref,
                                      ref
                                          .read(currentAccountProvider)
                                          ?.user
                                          .host,
                                      emojis,
                                    ),
                                  ),
                                ).render(
                                  parseText(
                                    option.text,
                                    ref.read(textParserProvider),
                                  ),
                                ),
                              );
                            },
                          ),
                          if (option.voteCount != null)
                            Text(
                              context.l10n
                                  .pollOptionVoteCount(option.voteCount ?? 0),
                              style: theme.textTheme.labelSmall,
                            ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          borderRadius: borderRadius,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    poll.allowMultipleChoices
                        ? context.l10n.pollTotalVotesMultiple(
                            poll.voteCount,
                            poll.voterCount ?? 0,
                          )
                        : context.l10n.pollTotalVotes(poll.voteCount),
                    style: theme.textTheme.labelSmall,
                  ),
                  Text(
                    // ignore: l10n
                    " • ",
                    style: theme.textTheme.labelSmall,
                  ),
                  Text(
                    poll.hasEnded
                        ? "Ended ${DateTime.now().difference(poll.endedAt).toStringHuman(context: context)} ago"
                        : "Ends in ${poll.endedAt.difference(DateTime.now()).toStringHuman(context: context)}",
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
