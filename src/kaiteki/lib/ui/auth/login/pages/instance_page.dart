import "dart:async";

import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/auth/login/constants.dart";
import "package:kaiteki/ui/auth/login/login_screen.dart";
import "package:kaiteki/utils/lower_case_text_formatter.dart";

class InstancePage extends StatefulWidget {
  final FutureOr<void> Function(String instance) onNext;
  final VoidCallback? onHandoff;

  final bool enabled;

  const InstancePage({
    required this.onNext,
    this.enabled = true,
    super.key,
    this.onHandoff,
  });

  @override
  State<InstancePage> createState() => _InstancePageState();
}

class _InstancePageState extends State<InstancePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _instanceController;
  final _instanceFieldKey = UniqueKey();

  @override
  void initState() {
    super.initState();

    _instanceController = TextEditingController();
  }

  @override
  void dispose() {
    _instanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: contentMargin,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: fieldMargin,
              child: TextFormField(
                key: _instanceFieldKey,
                enabled: widget.enabled,
                autofillHints: const [AutofillHints.impp, AutofillHints.url],
                controller: _instanceController,
                autofocus: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  contentPadding: fieldPadding,
                  hintText: l10n.instanceFieldHint,
                  prefixIcon: const Icon(Icons.public_rounded),
                  prefixIconConstraints: iconConstraint,
                ),
                inputFormatters: [LowerCaseTextFormatter()],
                keyboardType: TextInputType.url,
                validator: _validateInstance,
                onFieldSubmitted: _submit,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(l10n.authInstructions),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (widget.onHandoff != null)
                      TextButton(
                        onPressed: widget.onHandoff,
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.comfortable,
                        ),
                        child: const Text("Sign in from other device"),
                      ),
                    const Spacer(),
                    FilledButton(
                      onPressed: widget.enabled ? _onNext : null,
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                      ),
                      child: Text(l10n.nextButtonLabel),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onNext() {
    if (_formKey.currentState?.validate() != true) return;
    _submit(_instanceController.text);
  }

  void _submit(String instance) {
    if (_formKey.currentState!.validate()) {
      var host = instance;

      // Extract host from URL, if necessary
      final uri = Uri.tryParse(host);
      if (uri != null && uri.host.isNotEmpty) {
        host = uri.host;
      }

      widget.onNext.call(host);
    }
  }

  String? _validateInstance(String? value) {
    if (value == null || value.isEmpty || !value.contains(".")) {
      return context.l10n.authNoInstance;
    }

    return null;
  }
}
