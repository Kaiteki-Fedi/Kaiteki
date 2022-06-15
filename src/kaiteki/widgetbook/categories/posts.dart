import 'package:flutter/material.dart' hide Visibility;
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/fediverse/model/visibility.dart';
import 'package:kaiteki/ui/shared/posts/post_widget.dart';
import 'package:widgetbook/widgetbook.dart';

import '../widgetboot_extensions.dart';

List<WidgetbookComponent> buildPostComponents() {
  return [
    WidgetbookComponent(
      name: "PostWidget",
      useCases: [
        WidgetbookUseCase(
          name: "Example post",
          builder: (context) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: PostWidget(
                  Post.example(),
                ),
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: "Customizable post",
          builder: (context) {
            final user = User(
              displayName: context.knobs.text(
                label: "Display name",
                initialValue: "User",
              ),
              host: context.knobs.text(
                label: "Instance",
                initialValue: "instance.social",
              ),
              id: '',
              avatarUrl: context.knobs.nullableText(
                label: "Avatar URL",
              ),
              source: null,
              username: context.knobs.text(
                label: "Username",
                initialValue: "User",
              ),
            );
            final post = Post(
              author: user,
              id: '',
              postedAt: DateTime.now().subtract(
                const Duration(minutes: 1),
              ),
              source: null,
              visibility: context.knobs.enumOptions(
                values: Visibility.values,
                label: "Visibility",
              ),
              content: context.knobs.nullableText(label: "Content"),
            );
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: PostWidget(post),
              ),
            );
          },
        )
      ],
    )
  ];
}
