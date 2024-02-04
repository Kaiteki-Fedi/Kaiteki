import "dart:async";

import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/auth/login/constants.dart";
import "package:kaiteki/ui/auth/login/login_screen.dart";
import "package:kaiteki/utils/lower_case_text_formatter.dart";

class InstancePage extends StatefulWidget {
  final FutureOr<void> Function(String instance) onNext;

  final bool enabled;

  const InstancePage({
    required this.onNext,
    this.enabled = true,
    super.key,
  });

  @override
  State<InstancePage> createState() => _InstancePageState();
}

class _InstancePageState extends State<InstancePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _instanceController;

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
              child: _InstanceField(
                enabled: widget.enabled,
                controller: _instanceController,
                onSubmit: _onSubmit,
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
    _onSubmit(_instanceController.text);
  }

  void _onSubmit(String instance) {
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
}

class _InstanceField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final Function(String host) onSubmit;

  const _InstanceField({
    required this.controller,
    required this.onSubmit,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: fieldMargin,
      child: TextFormField(
        enabled: enabled,
        autofillHints: const [AutofillHints.impp, AutofillHints.url],
        controller: controller,
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
        validator: (value) {
          if (value == null || value.isEmpty || !value.contains(".")) {
            return context.l10n.authNoInstance;
          }

          return null;
        },
        onFieldSubmitted: onSubmit.call,
      ),
    );
  }
}
