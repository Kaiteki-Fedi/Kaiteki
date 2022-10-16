import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';
import 'package:kaiteki/utils/extensions.dart';

class UserCard extends ConsumerWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const size = 48.0;
    const padding = 12.0;
    final textShadow = Shadow(
      blurRadius: 2,
      offset: const Offset(0, 1.0),
      color: Colors.black.withOpacity(0.75),
    );
    final description = user.description;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 8.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: size / 2),
                child: SizedBox(
                  height: 100,
                  child: buildHeader(context),
                ),
              ),
              Positioned(
                left: padding,
                right: padding,
                bottom: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ignore: avoid_redundant_argument_values
                    AvatarWidget(size: size, user),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text.rich(
                              user.renderDisplayName(context, ref),
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [textShadow],
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              user.handle,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: TextStyle(
                                color: Theme.of(context).disabledColor,
                              ),
                              textScaleFactor: 0.85,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(padding),
            child: Column(
              children: [
                if (description != null)
                  Text.rich(
                    user.renderText(context, ref, description.trim()),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    final bannerUrl = user.bannerUrl;
    if (bannerUrl != null) {
      return Image.network(
        bannerUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        isAntiAlias: true,
        filterQuality: FilterQuality.medium,
        height: 100,
      );
    } else {
      return Container(
        color: Theme.of(context).colorScheme.surfaceVariant,
      );
    }
  }
}
