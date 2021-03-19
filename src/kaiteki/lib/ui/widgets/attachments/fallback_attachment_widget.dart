import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/attachment.dart';
import 'package:mdi/mdi.dart';
import 'package:url_launcher/url_launcher.dart';

class FallbackAttachmentWidget extends StatelessWidget {
  const FallbackAttachmentWidget({
    @required this.attachment,
    Key key,
  }) : super(key: key);

  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Wrap(
        direction: Axis.vertical,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 6,
        children: [
          Icon(Mdi.fileAlertOutline),
          Text('Unsupported attachment'),
          OutlinedButton(
            child: Text('View online'),
            onPressed: () async {
              await launch(attachment.url);
            },
          ),
        ],
      ),
    );
  }
}
