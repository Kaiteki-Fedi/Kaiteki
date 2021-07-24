import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/fediverse/model/attachment.dart';
import 'package:mdi/mdi.dart';

class AttachmentInspectionScreen extends StatefulWidget {
  final Iterable<Attachment> attachments;
  final int index;

  const AttachmentInspectionScreen({
    Key? key,
    required this.attachments,
    required this.index,
  }) : super(key: key);

  @override
  _AttachmentInspectionScreenState createState() =>
      _AttachmentInspectionScreenState();
}

class _AttachmentInspectionScreenState
    extends State<AttachmentInspectionScreen> {
  late final PageController controller;
  late int currentPage;
  static const duration = Duration(milliseconds: 150);

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

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        title: buildTitle(context),
        centerTitle: true,
        actions: const [
          IconButton(
            icon: Icon(Mdi.download),
            onPressed: null,
            tooltip: "Download attachment",
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!singleAttachment)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  mini: true,
                  onPressed: canNavigateBackwards ? previousPage : null,
                  child: Opacity(
                    opacity: canNavigateBackwards ? 1 : .25,
                    child: const Icon(Mdi.chevronLeft),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  mini: true,
                  onPressed: canNavigateForwards ? nextPage : null,
                  child: Opacity(
                    opacity: canNavigateForwards ? 1 : .25,
                    child: const Icon(Mdi.chevronRight),
                  ),
                ),
              ),
          ],
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
    final attachment = widget.attachments.elementAt(currentPage);

    if (attachment.description == null)
      return ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          "${currentPage + 1}/$count",
          style: TextStyle(color: Colors.white),
        ),
      );
    else
      return ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          attachment.description!,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          "${currentPage + 1}/$count",
          style: TextStyle(color: Colors.white70),
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
      default:
        return Text("Hello world!");
    }
  }
}
