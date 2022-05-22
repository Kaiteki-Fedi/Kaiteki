import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

class MisskeyPagePostWidget extends StatefulWidget {
  const MisskeyPagePostWidget(this.content, {Key? key}) : super(key: key);

  final String content;

  @override
  State<MisskeyPagePostWidget> createState() => _MisskeyPagePostWidgetState();
}

class _MisskeyPagePostWidgetState extends State<MisskeyPagePostWidget> {
  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController(text: widget.content);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          textAlignVertical: TextAlignVertical.top,
          minLines: 5,
          maxLines: 5,
          controller: textController,
          readOnly: true,
        ),
        const ElevatedButton(
          child: Icon(Mdi.send),
          // TODO(Craftplacer): (misskey) make status post component functional
          onPressed: null,
        )
      ],
    );
  }
}
