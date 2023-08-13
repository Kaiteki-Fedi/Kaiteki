import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/model.dart";

class PostSignature extends ConsumerWidget {
  const PostSignature(this.post, {super.key});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outlineColor = Theme.of(context).colorScheme.outline;
    return Column(
      children: [
        const SizedBox(
          width: 48,
          child: Divider(height: 25),
        ),
        Text.rich(
          post.author.renderDescription(context, ref),
          style: outlineColor.textStyle,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
