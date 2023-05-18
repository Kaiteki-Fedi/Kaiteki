import "package:flutter/material.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:storybook_flutter/storybook_flutter.dart";

final avatars = Story(
  name: "Avatars",
  builder: (context) {
    return Wrap(
      runSpacing: 16,
      spacing: 16,
      children: [
        for (final type in UserType.values)
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 100,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(type.name),
                const SizedBox(height: 8),
                AvatarWidget.url(
                  null,
                  type: type,
                ),
              ],
            ),
          ),
      ],
    );
  },
);
