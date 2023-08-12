import "package:flutter/material.dart";
import "package:kaiteki/ui/shared/posts/poll_widget.dart";
import "package:kaiteki_core/model.dart";
import "package:storybook_flutter/storybook_flutter.dart";

final poll = Story(
  builder: (_) => Card(
    child: SizedBox(
      width: 350,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PollWidget(
          Poll(
            hasEnded: false,
            endedAt: DateTime.now().add(const Duration(days: 1)),
            allowMultipleChoices: false,
            id: "0",
            voteCount: 15,
            voterCount: 15,
            options: const [
              PollOption("Cats", 8),
              PollOption("Dogs", 5),
              PollOption("Birds", 2),
            ],
          ),
        ),
      ),
    ),
  ),
  name: "Posts/Poll",
);
