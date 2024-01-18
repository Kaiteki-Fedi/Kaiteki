import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/text/text_context.dart";
import "package:kaiteki/text/text_renderer.dart";
import "package:kaiteki/ui/shared/common.dart";
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
    final endsAt = poll.endsAt;
    return Padding(
      padding: padding,
      child: Column(
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
            PollOptionWidget.fromOption(
              option,
              emojis: emojis,
              totalVotes: poll.voteCount,
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
              if (endsAt != null) ...[
                Text(
                  // ignore: l10n
                  " • ",
                  style: theme.textTheme.labelSmall,
                ),
                Text(
                  poll.hasEnded
                      ? "Ended ${DateTime.now().difference(endsAt).toStringHuman(context: context)} ago"
                      : "Ends in ${endsAt.difference(DateTime.now()).toStringHuman(context: context)}",
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class PollOptionWidget extends ConsumerWidget {
  const PollOptionWidget({
    super.key,
    this.emojis = const [],
    required this.text,
    this.voteCount,
    this.totalVotes,
  }) : assert(
          totalVotes == null || totalVotes >= 0,
          "totalVotes must be positive",
        );

  PollOptionWidget.fromOption(
    PollOption option, {
    Key? key,
    List<CustomEmoji> emojis = const [],
    int? totalVotes,
  }) : this(
          key: key,
          emojis: emojis,
          text: option.text,
          voteCount: option.voteCount,
          totalVotes: totalVotes,
        );

  final List<CustomEmoji> emojis;
  final int? totalVotes;
  final int? voteCount;
  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    const shape = Shapes.small;

    final voteCount = this.voteCount;
    final totalVotes = this.totalVotes;
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: shape.copyWith(
          side: BorderSide(color: theme.colorScheme.outline),
        ),
      ),
      child: Stack(
        children: [
          if (voteCount != null && totalVotes != null && totalVotes > 0)
            Positioned.fill(
              child: FractionallySizedBox(
                widthFactor: voteCount / totalVotes,
                alignment: Alignment.centerLeft,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: theme.colorScheme.primary.withOpacity(.25),
                    shape: shape,
                  ),
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
                Text.rich(renderOptionText(context, ref)),
                if (voteCount != null)
                  Text(
                    context.l10n.pollOptionVoteCount(voteCount),
                    style: theme.textTheme.labelSmall,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InlineSpan renderOptionText(BuildContext context, WidgetRef ref) {
    return TextRenderer.fromContext(
      context,
      ref,
      TextContext(
        // HACK(Craftplacer): this is jank
        emojiResolver: (e) => resolveEmoji(
          e,
          ref,
          ref.read(currentAccountProvider)?.user.host,
          emojis,
        ),
      ),
    ).render(
      parseText(
        text,
        ref.read(textParserProvider),
      ),
    );
  }
}
