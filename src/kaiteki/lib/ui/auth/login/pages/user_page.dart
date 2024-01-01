import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/auth/login/constants.dart";
import "package:kaiteki/ui/auth/login/login_screen.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/error_message.dart";

const _instanceIconSize = 96.0;

class UserPage extends StatefulWidget {
  final String? image;

  final FutureOr<void> Function(String username, String password)? onSubmit;

  const UserPage({
    this.image,
    this.onSubmit,
    super.key,
  });

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<void>? _future;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: _InstanceIcon(url: widget.image),
                    ),
                  ),
                  Padding(
                    padding: fieldMargin,
                    child: _UsernameField(controller: _usernameController),
                  ),
                  Padding(
                    padding: fieldMargin,
                    child: _PasswordField(controller: _passwordController),
                  ),
                  if (snapshot.hasError)
                    Padding(
                      padding: fieldMargin,
                      child: ErrorMessageWidget(snapshot.traceableError!),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Tooltip(
                          message: l10n.niy,
                          child: TextButton(
                            onPressed: null,
                            child: Text(l10n.forgotPasswordButtonLabel),
                          ),
                        ),
                        const Spacer(),
                        FilledButton(
                          onPressed: _onLogin,
                          child: Text(l10n.loginButtonLabel),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onLogin() async {
    if (_formKey.currentState?.validate() != true) return;

    final callback = widget.onSubmit;
    if (callback == null) return;

    setState(() {
      _future = Future.sync(
        () async => callback(
          _usernameController.text,
          _passwordController.text,
        ),
      );
    });
  }
}

class _UsernameField extends StatelessWidget {
  final TextEditingController controller;

  const _UsernameField({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      controller: controller,
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.surface.withOpacity(.75),
        filled: true,
        hintText: context.l10n.usernameFieldHint,
        prefixIcon: const Icon(Icons.person_rounded),
        prefixIconConstraints: iconConstraint,
        border: const OutlineInputBorder(),
        contentPadding: fieldPadding,
      ),
      autofillHints: const [AutofillHints.username],
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value?.trim().isNotEmpty == true) return null;
        return context.l10n.authNoUsername;
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;

  const _PasswordField({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.surface.withOpacity(.75),
        filled: true,
        hintText: context.l10n.passwordFieldHint,
        prefixIcon: const Icon(Icons.vpn_key_rounded),
        prefixIconConstraints: iconConstraint,
        border: const OutlineInputBorder(),
        contentPadding: fieldPadding,
      ),
      // validator: widget.passwordValidator,
      keyboardType: TextInputType.text,
      autofillHints: const [AutofillHints.password],
      obscureText: true,
      validator: (value) {
        if (value?.trim().isNotEmpty == true) return null;
        return context.l10n.authNoPassword;
      },
    );
  }
}

class _InstanceIcon extends StatelessWidget {
  final String? url;

  const _InstanceIcon({this.url});

  @override
  Widget build(BuildContext context) {
    final url = this.url;
    if (url == null) return const _IconPlaceholder();

    final isSvg = url.toLowerCase().endsWith(".svg");
    if (isSvg) {
      return SvgPicture.network(
        url,
        width: _instanceIconSize,
        placeholderBuilder: (_) => const _IconPlaceholder(),
      );
    }

    return Image.network(
      url,
      width: _instanceIconSize,
      cacheWidth: _instanceIconSize.toInt(),
      frameBuilder: (_, child, frame, __) =>
          frame != null ? child : const _IconPlaceholder(),
      errorBuilder: (_, __, ___) => const _IconPlaceholder(),
    );
  }
}

class _IconPlaceholder extends StatelessWidget {
  const _IconPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox.square(
      dimension: _instanceIconSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Icon(
          Icons.public,
          size: 64.0,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
