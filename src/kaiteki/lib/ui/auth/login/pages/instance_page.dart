import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/instances.dart';
import 'package:kaiteki/ui/auth/discover_instances/discover_instance_screen_result.dart';
import 'package:kaiteki/ui/auth/discover_instances/discover_instances_screen.dart';
import 'package:kaiteki/ui/auth/login/constants.dart';
import 'package:kaiteki/ui/auth/login/login_form.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:kaiteki/utils/lower_case_text_formatter.dart';

class InstancePage extends StatefulWidget {
  final FutureOr<void> Function(String instance) onNext;
  final FutureOr<void> Function(String instance)? onRegister;
  final bool enabled;

  const InstancePage({
    required this.onNext,
    this.onRegister,
    this.enabled = true,
    super.key,
  });

  @override
  State<InstancePage> createState() => _InstancePageState();
}

class _InstancePageState extends State<InstancePage> {
  final _formKey = GlobalKey<FormState>();
  List<InstanceData>? _instances;
  late TextEditingController _instanceController;

  @override
  void initState() {
    super.initState();

    _instanceController = TextEditingController();

    fetchInstances().then(
      (list) => setState(() => _instances = list),
    );
  }

  @override
  void dispose() {
    _instanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();
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
                TextButton(
                  onPressed:
                      widget.enabled ? _onDiscoverInstancesPressed : null,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(l10n.discoverInstancesButtonLabel),
                ),
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(l10n.authInstructions),
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.onRegister == null)
                      const SizedBox()
                    else
                      TextButton(
                        // TODO(Craftplacer): This doesn't call widget.onRegister
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.comfortable,
                        ),
                        child: Text(l10n.registerButtonLabel),
                      ),
                    ElevatedButton(
                      onPressed: widget.enabled ? _onNext : null,
                      style: Theme.of(context).filledButtonStyle.copyWith(
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

  Future<void> _onDiscoverInstancesPressed() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DiscoverInstancesScreen(),
      ),
    );

    if (result is DiscoverInstanceScreenResult) {
      _instanceController.text = result.instance;
      _submit(result.instance);
    }
  }

  String? _validateInstance(String? value) {
    if (value == null || value.isEmpty || !value.contains(".")) {
      return context.getL10n().authNoInstance;
    }

    return null;
  }
}
