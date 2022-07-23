import 'package:fediverse_objects/mastodon.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/utils/extensions/build_context.dart';
import 'package:kaiteki/utils/extensions/string.dart';

class ApplicationWidget extends StatelessWidget {
  final Application application;

  const ApplicationWidget(this.application, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasWebsite = application.website.isNotNullOrEmpty;

    return InkWell(
      enableFeedback: hasWebsite,
      onTap: () => context.launchUrl(application.website!),
      child: Text(
        application.name,
        style: TextStyle(color: hasWebsite ? theme.primaryColor : null),
      ),
    );
  }
}
