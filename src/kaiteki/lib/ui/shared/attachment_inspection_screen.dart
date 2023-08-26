import "dart:io";

import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:http/http.dart" as http;
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki_core/model.dart";

class AttachmentInspectionScreen extends StatefulWidget {
  final List<Attachment> attachments;
  final int index;

  const AttachmentInspectionScreen({
    super.key,
    required this.attachments,
    required this.index,
  });

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
    final l10n = context.l10n;

    final pageView = PageView(
      controller: controller,
      children: [
        for (final attachment in widget.attachments)
          _getAttachmentWidget(attachment),
      ],
    );

    final previousButton = FloatingActionButton(
      mini: true,
      onPressed: canNavigateBackwards ? previousPage : null,
      tooltip: MaterialLocalizations.of(context).previousPageTooltip,
      child: Opacity(
        opacity: canNavigateBackwards ? 1 : .25,
        child: const Icon(Icons.chevron_left_rounded),
      ),
    );

    final nextButton = FloatingActionButton(
      mini: true,
      onPressed: canNavigateForwards ? nextPage : null,
      tooltip: MaterialLocalizations.of(context).nextPageTooltip,
      child: Opacity(
        opacity: canNavigateForwards ? 1 : .25,
        child: const Icon(Icons.chevron_right_rounded),
      ),
    );

    final hasDescription = attachment.description?.isNotEmpty == true;
    return Scaffold(
      backgroundColor: background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: Colors.white,
        title: buildTitle(context),
        actions: [
          IconButton(
            icon: const Icon(Icons.subtitles_rounded),
            onPressed: hasDescription ? _showAltText : null,
            tooltip: context.l10n.showAltTextTooltip,
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () => downloadAttachment(context),
            tooltip: l10n.attachmentDownloadButtonLabel,
          ),
          PopupMenuButton(itemBuilder: _buildPopupMenu),
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
          child: OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                return Stack(
                  children: [
                    pageView,
                    if (!singleAttachment)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              previousButton,
                              const SizedBox(width: 8),
                              nextButton,
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              }

              return Stack(
                children: [
                  pageView,
                  if (!singleAttachment)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: previousButton,
                        ),
                      ),
                    ),
                  if (!singleAttachment)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      child: Align(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: nextButton,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  List<PopupMenuEntry> _buildPopupMenu(BuildContext context) {
    final l10n = context.l10n;
    return [
      PopupMenuItem(
        child: Text(l10n.copyAttachmentUrl),
        onTap: () async {
          final uri = attachment.url;
          final data = ClipboardData(text: uri.toString());
          await Clipboard.setData(data);
          if (mounted) {
            final snackBar = SnackBar(
              content: Text(l10n.copiedToClipboard),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
      ),
    ];
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
    final l10n = context.l10n;

    return Text(
      l10n.pageViewTitle(currentPage + 1, count),
      style: TextStyle(color: Colors.white.withOpacity(.8)),
    );
  }

  Widget _getAttachmentWidget(Attachment attachment) {
    switch (attachment.type) {
      case AttachmentType.image:
        return InteractiveViewer(
          child: Center(
            child: Image.network(
              attachment.url.toString(),
              fit: BoxFit.fill,
              semanticLabel: attachment.description,
            ),
          ),
        );
      default:
        throw ArgumentError.value(
          attachment.type,
          "attachment",
          "Can't build widget for specified attachment type",
        );
    }
  }

  Future<void> downloadAttachment(BuildContext context) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);

    final uri = attachment.url;
    final filePath = await FilePicker.platform.saveFile(
      fileName: uri.pathSegments.last,
      dialogTitle: l10n.attachmentDownloadDialogTitle,
    );

    if (filePath == null) return;

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

  Future<void> _showAltText() async {
    final description = attachment.description;
    if (description == null) return;
    await showModalBottomSheet(
      context: context,
      constraints: bottomSheetConstraints,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.l10n.altText,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}
