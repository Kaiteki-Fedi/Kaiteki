import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kaiteki/fediverse/model/attachment.dart';
import 'package:kaiteki/utils/extensions/build_context.dart';
import 'package:mdi/mdi.dart';

class FallbackAttachmentWidget extends StatelessWidget {
  const FallbackAttachmentWidget({
    required this.attachment,
    Key? key,
  }) : super(key: key);

  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Wrap(
        direction: Axis.vertical,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 6,
        children: [
          const Icon(Mdi.fileAlertOutline),
          Text(l10n.attachmentUnsupported),
          OutlinedButton(
            child: Text(l10n.viewOnlineButtonLabel),
            onPressed: () => context.launchUrl(attachment.url),
          ),
        ],
      ),
    );
  }
}
