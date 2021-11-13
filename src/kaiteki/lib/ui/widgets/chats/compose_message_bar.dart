import 'package:flutter/material.dart';

typedef MessageCallback = void Function(
  String content,
  List<dynamic> attachments,
);

class ComposeMessageBar extends StatelessWidget {
  ComposeMessageBar({
    Key? key,
    required this.onSendMessage,
  }) : super(key: key);

  final MessageCallback onSendMessage;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 6.0, right: 12.0),
          child: IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: null,
            splashRadius: 24,
            tooltip: "Attach",
          ),
        ),
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Write a message...",
              border: InputBorder.none,
            ),
            onSubmitted: (String input) {
              onSendMessage.call(input, []);
            },
            maxLines: null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 6.0, left: 12.0),
          child: IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final input = _controller.value.text;
              onSendMessage.call(input, []);
            },
            splashRadius: 24,
            tooltip: "Send message",
          ),
        ),
      ],
    );
  }
}
