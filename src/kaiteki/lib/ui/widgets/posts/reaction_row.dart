import 'package:flutter/material.dart';
import 'package:kaiteki/model/fediverse/post.dart';
import 'package:kaiteki/model/fediverse/reaction.dart';
import 'package:kaiteki/ui/widgets/posts/reaction_widget.dart';

class ReactionRow extends StatelessWidget {
  final Iterable<Reaction> _reactions;
  final Post _parentPost;

  const ReactionRow(this._parentPost, this._reactions);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,

      children: [
        for (var reaction in _reactions)
          ReactionWidget(parentPost: _parentPost, reaction: reaction),
      ],
    );
  }
}
