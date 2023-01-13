import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:kaiteki/ui/shared/common.dart";

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Feedback"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email Address (optional)",
                  filled: true,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.help_outline_rounded,
                    ),
                    splashRadius: 24,
                    onPressed: _onEmailTap,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Message",
                  alignLabelWithHint: true,
                  filled: true,
                ),
                minLines: 8,
                maxLines: null,
              ),
              const SizedBox(height: 24),
              Text.rich(
                TextSpan(
                  text:
                      "Additional information like app version, system information and internal errors will be sent alongside your message. ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  children: [
                    TextSpan(
                      text: "Learn More",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = _onDetailsTap,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: const Text("Send"),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onEmailTap() async {
    return showTextAlert(
      context,
      "How your email address will be used",
      "You can leave your email address to make it possible for us to reply to your inquiry. Your email address will be used for no other purpose.",
    );
  }

  Future<void> _onDetailsTap() async {
    return showTextAlert(
      context,
      "Example of additional information sent",
      "",
    );
  }
}
