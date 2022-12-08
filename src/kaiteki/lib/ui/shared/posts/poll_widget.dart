import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/poll.dart';
import 'package:kaiteki/utils/extensions.dart';

class PollWidget extends StatelessWidget {
  final Poll poll;
  final EdgeInsets padding;

  const PollWidget(this.poll, {super.key, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //final maxVotes = poll.options.map((o) => o.voteCount).max;
    return Padding(
      padding: padding,
      child: LayoutBuilder(builder: (context, constraints) {
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SizedBox(
                          width: constraints.maxWidth *
                              (option.voteCount! / poll.voteCount),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                      vertical: 2,
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
                  " - ",
                  style: theme.textTheme.labelSmall,
                ),
                Text(
                  "Ends in ${poll.endedAt.difference(DateTime.now()).toStringHuman(
                        context: context,
                      )}",
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
