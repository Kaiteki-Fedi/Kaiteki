import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:google_fonts/google_fonts.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/auth/login/constants.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/error_message.dart";
import "package:kaiteki_core/social.dart";

// TODO(Craftplacer): Revamp CodePage, to reflect various code inputs & refresh UI.
class CodePage extends StatefulWidget {
  final CodePromptOptions options;
  final FutureOr<void> Function(String code) onSubmit;

  const CodePage({super.key, required this.onSubmit, required this.options});

  @override
  State<CodePage> createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future? _future;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final large = widget.options.length != null && widget.options.length! <= 8;
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return AsyncBlockWidget(
          blocking: snapshot.connectionState == ConnectionState.waiting,
          duration: const Duration(milliseconds: 250),
          secondChild: centeredCircularProgressIndicator,
          child: Padding(
            padding: contentMargin,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(l10n.mfaInstructions),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: _CodeField(
                            controller: _textController,
                            onSubmit: _submit,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: large
                            ? FloatingActionButton(
                                onPressed: () => _submit(_textController.text),
                                elevation: 0.0,
                                tooltip: l10n.submitButtonTooltip,
                                heroTag: null,
                                child: const Icon(Icons.arrow_forward_rounded),
                              )
                            : FloatingActionButton.small(
                                onPressed: () => _submit(_textController.text),
                                elevation: 0.0,
                                tooltip: l10n.submitButtonTooltip,
                                heroTag: null,
                                child: const Icon(Icons.arrow_forward_rounded),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (snapshot.hasError)
                    ErrorMessageWidget(snapshot.traceableError!),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _submit(String code) {
    if (_formKey.currentState?.validate() != true) return;

    setState(() {
      _future = Future.sync(() => widget.onSubmit(code));
    });
  }
}

class _CodeField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String code) onSubmit;

  const _CodeField({
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextFormField(
      autofillHints: const [AutofillHints.oneTimeCode],
      controller: controller,
      decoration: const InputDecoration(
        isDense: true,
        border: OutlineInputBorder(),
      ),
      textAlign: TextAlign.center,
      keyboardType: TextInputType.visiblePassword,
      maxLength: 6,
      style: GoogleFonts.robotoMono(fontSize: 24),
      textInputAction: TextInputAction.done,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      autofocus: true,
      autocorrect: false,
      validator: (code) {
        return code?.isEmpty == false ? null : l10n.mfaNoCode;
      },
    );
  }
}
