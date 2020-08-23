import 'package:flutter/material.dart';
import 'package:kaiteki/api/model/mastodon/application.dart';
import 'package:kaiteki/utils/logger.dart';
import 'package:kaiteki/utils/string_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplicationWidget extends StatelessWidget {
  final MastodonApplication application;

  const ApplicationWidget(this.application, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: make use of pleroma's link color property
    var theme = Theme.of(context);
    var hasWebsite = application.website.isNotNullOrEmpty;

    return InkWell(
      enableFeedback: hasWebsite,
      onTap: () async {
        var url = application.website;

        if (url == null) {
          Logger.warning("Tried to open a null application website URL");
          return;
        }

        if (!await canLaunch(url))
          throw 'Could not launch $url';

        await launch(url);
      },
      child: Text(
        application.name,
        style: TextStyle(color: hasWebsite ? theme.primaryColor : null)
      ),
    );
  }
}
