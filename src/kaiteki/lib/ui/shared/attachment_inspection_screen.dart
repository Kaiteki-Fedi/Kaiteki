import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/attachment.dart';

class AttachmentInspectionScreen extends StatefulWidget {
  final Iterable<Attachment> attachments;
  final int index;

  const AttachmentInspectionScreen({
    Key? key,
    required this.attachments,
    required this.index,
  }) : super(key: key);

  @override
  State<AttachmentInspectionScreen> createState() =>
      _AttachmentInspectionScreenState();
}

class _AttachmentInspectionScreenState
    extends State<AttachmentInspectionScreen> {
  late final PageController controller;
  late int currentPage;
  static const duration = Duration(milliseconds: 150);

  Attachment get attachment => widget.attachments.elementAt(currentPage);

  bool get canNavigateBackwards => currentPage > 0;
  bool get canNavigateForwards => currentPage < (widget.attachments.length - 1);

  @override
  void initState() {
    super.initState();

    currentPage = widget.index;
    controller = PageController(initialPage: currentPage);
  }

  @override
  Widget build(BuildContext context) {
    final background = Colors.black.withOpacity(.5);
    final count = widget.attachments.length;
    final singleAttachment = count == 1;
    final focusNode = FocusNode();
    final l10n = context.getL10n();

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        title: buildTitle(context),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () => downloadAttachment(context),
            tooltip: l10n.attachmentDownloadButtonLabel,
          ),
        ],
      ),
      body: RawKeyboardListener(
        focusNode: focusNode,
        autofocus: true,
        onKey: (key) {
          if (key.data.logicalKey == LogicalKeyboardKey.arrowLeft) {
            previousPage();
          } else if (key.data.logicalKey == LogicalKeyboardKey.arrowRight) {
            nextPage();
          }
        },
        child: Theme(
          data: Theme.of(context).copyWith(
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Theme.of(context).colorScheme.inverseSurface,
              foregroundColor: Theme.of(context).colorScheme.onInverseSurface,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!singleAttachment)
                Align(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: canNavigateBackwards ? previousPage : null,
                      child: Opacity(
                        opacity: canNavigateBackwards ? 1 : .25,
                        child: const Icon(Icons.chevron_left_rounded),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: PageView(
                  controller: controller,
                  children: [
                    for (var attachment in widget.attachments)
                      _getAttachmentWidget(attachment),
                  ],
                ),
              ),
              if (!singleAttachment)
                Align(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: canNavigateForwards ? nextPage : null,
                      child: Opacity(
                        opacity: canNavigateForwards ? 1 : .25,
                        child: const Icon(Icons.chevron_right_rounded),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void nextPage() {
    if (!canNavigateForwards) return;

    setState(() => currentPage++);
    controller.nextPage(
      duration: duration,
      curve: Curves.easeOutExpo,
    );
  }

  void previousPage() {
    if (!canNavigateBackwards) return;

    setState(() => currentPage--);
    controller.previousPage(
      duration: duration,
      curve: Curves.easeOutExpo,
    );
  }

  Widget buildTitle(BuildContext context) {
    final count = widget.attachments.length;
    final hasDescription = attachment.description?.isNotEmpty == true;
    final l10n = context.getL10n();

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        hasDescription ? attachment.description! : l10n.attachmentNoDescription,
        style: TextStyle(
          color: Colors.white,
          fontStyle: hasDescription ? null : FontStyle.italic,
        ),
      ),
      subtitle: Text(
        "${currentPage + 1}/$count",
        style: TextStyle(color: Colors.white.withOpacity(.8)),
      ),
    );

    //return Wrap(
    //  crossAxisAlignment: WrapCrossAlignment.center,
    //  direction: Axis.horizontal,
    //  children: [
    //    if (attachment.description != null) Text(attachment.description!),
    //    buildBadge(context, "${currentPage + 1}/$count"),
    //  ],
    //);
  }

  Widget buildBadge(BuildContext context, String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(left: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
      child: Text(
        text,
        style: GoogleFonts.robotoMono(color: Colors.black),
        overflow: TextOverflow.fade,
        textScaleFactor: .75,
      ),
    );
  }

  Widget _getAttachmentWidget(Attachment attachment) {
    switch (attachment.type) {
      case AttachmentType.image:
        return InteractiveViewer(
          child: Center(
            child: Image.network(
              attachment.url,
              fit: BoxFit.fill,
              semanticLabel: attachment.description,
            ),
          ),
        );
    }

    throw ArgumentError.value(
      attachment.type,
      "attachment",
      "Can't build widget for specified attachment type",
    );
  }

  Future<void> downloadAttachment(BuildContext context) async {
    final l10n = context.getL10n();
    final messenger = ScaffoldMessenger.of(context);

    final uri = Uri.parse(attachment.url);
    final filePath = await FilePicker.platform.saveFile(
      fileName: uri.pathSegments.last,
      dialogTitle: l10n.attachmentDownloadDialogTitle,
    );

    if (filePath == null) {
      return;
    }

    final request = http.Request("GET", uri);
    final response = await request.send();

    if (response.statusCode == 200) {
      final file = await File(filePath).create();
      final sink = file.openWrite();

      var snackBar = messenger.showSnackBar(
        SnackBar(content: Text(l10n.attachmentDownloadInProgress)),
      );

      await response.stream.pipe(sink);

      snackBar.close();
      snackBar = messenger.showSnackBar(
        SnackBar(
          content: Text(
            l10n.attachmentDownloadSuccessful(file.uri.pathSegments.last),
          ),
        ),
      );
    }
  }
}
