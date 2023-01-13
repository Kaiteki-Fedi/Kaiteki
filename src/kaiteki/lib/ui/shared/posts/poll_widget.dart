import "package:flutter/material.dart";
import "package:kaiteki/fediverse/model/poll.dart";
import "package:kaiteki/utils/extensions.dart";

class PollWidget extends StatelessWidget {
  final Poll poll;
  final EdgeInsets padding;

  const PollWidget(this.poll, {super.key, this.padding = EdgeInsets.zero});

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
                          Text(option.text),
                          Text(
                            "${option.voteCount} votes",
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
                )
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    "${poll.voteCount} votes from ${poll.voterCount} people",
                    style: theme.textTheme.labelSmall,
                  ),
                  Text(
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
