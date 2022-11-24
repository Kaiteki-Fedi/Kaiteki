import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/reaction.dart';
import 'package:kaiteki/ui/shared/posts/reaction_button.dart';

class ReactionRow extends StatelessWidget {
  final List<Reaction> reactions;
  final Function(Reaction reaction) onPressed;

  const ReactionRow(
    this.reactions,
    this.onPressed, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: [
        for (var reaction in reactions)
          ReactionButton(
            reaction: reaction,
            onPressed: () => onPressed(reaction),
          ),
      ],
    );
  }
}
