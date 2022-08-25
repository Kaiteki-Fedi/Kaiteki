import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/ui/auth/login/constants.dart';
import 'package:kaiteki/ui/shared/async_block_widget.dart';
import 'package:kaiteki/ui/shared/error_message.dart';

class MfaPage extends StatefulWidget {
  final FutureOr<void> Function(String code) onSubmit;

  const MfaPage({super.key, required this.onSubmit});

  @override
  State<MfaPage> createState() => _MfaPageState();
}

class _MfaPageState extends State<MfaPage> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future? _future;

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return AsyncBlockWidget(
          blocking: snapshot.connectionState == ConnectionState.waiting,
          duration: const Duration(milliseconds: 250),
          secondChild: const Center(child: CircularProgressIndicator()),
          child: Padding(
            padding: contentMargin,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "This account uses Multi-Factor Authentication, please enter the code below:",
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: TextFormField(
                            autofillHints: const [AutofillHints.oneTimeCode],
                            controller: _textController,
                            decoration: const InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.visiblePassword,
                            maxLength: 8,
                            style: GoogleFonts.robotoMono(fontSize: 24),
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            autofocus: true,
                            autocorrect: false,
                            onFieldSubmitted: _submit,
                            validator: (code) {
                              return code?.isEmpty == false
                                  ? null
                                  : l10n.mfaNoCode;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: FloatingActionButton(
                          onPressed: () => _submit(_textController.text),
                          elevation:
                              Theme.of(context).useMaterial3 ? 0.0 : null,
                          tooltip: "Submit",
                          heroTag: null,
                          child: const Icon(Icons.arrow_forward_rounded),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (snapshot.hasError)
                    ErrorMessageWidget(
                      error: snapshot.error!,
                      stackTrace: snapshot.stackTrace,
                    ),
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
