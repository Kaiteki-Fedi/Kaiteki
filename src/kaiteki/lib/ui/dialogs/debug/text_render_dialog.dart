import 'package:flutter/material.dart' hide Element;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:kaiteki/utils/text/elements.dart';
import 'package:kaiteki/utils/text/parsers.dart';

class TextRenderDialog extends ConsumerStatefulWidget {
  final Post post;

  const TextRenderDialog(this.post, {Key? key}) : super(key: key);

  @override
  ConsumerState<TextRenderDialog> createState() => _TextRenderDialogState();
}

class _TextRenderDialogState extends ConsumerState<TextRenderDialog>
    with TickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final elements = MastodonHtmlTextParser()
        .parse(widget.post.content!)
        .parseWith(SocialTextParser())
        .parseWith(MfmTextParser());

    return AlertDialog(
      title: const Text("Text rendering"),
      content: SizedBox(
        width: 800,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              controller: _controller,
              unselectedLabelColor: Theme.of(context).colorScheme.onBackground,
              labelColor: Theme.of(context).colorScheme.primary,
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: const [
                Tab(child: Text("Raw")),
                Tab(child: Text("Elements")),
                Tab(child: Text("Rendered")),
              ],
            ),
            const Divider(height: 1),
            const SizedBox(height: 7),
            Flexible(
              child: TabBarView(
                controller: _controller,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.robotoMono(),
                    controller:
                        TextEditingController(text: widget.post.content),
                    readOnly: true,
                    expands: false,
                    maxLines: null,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.robotoMono(),
                    controller: TextEditingController(
                      text: elements.map(getTree).join("\n"),
                    ),
                    readOnly: true,
                    expands: false,
                    maxLines: null,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).disabledColor,
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text.rich(
                      widget.post.renderContent(context, ref),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getTree(Element element) {
    String a = element.toString();

    final children = element.children;
    if (children != null) {
      for (var child in children) {
        final childResult = getTree(child);
        a += "\n$childResult";
      }
    }

    return a.split("\n").join("\n⮩ ");
  }
}
