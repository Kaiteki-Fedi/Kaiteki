import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/ui/auth/login/constants.dart';
import 'package:kaiteki/ui/auth/login/login_form.dart';
import 'package:kaiteki/ui/shared/common.dart';
import 'package:kaiteki/ui/shared/error_message.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:kaiteki_material/kaiteki_material.dart';

const _instanceIconSize = 96.0;

class UserPage extends StatefulWidget {
  final String? image;

  final VoidCallback? onBack;
  final FutureOr<void> Function(String username, String password)? onSubmit;

  const UserPage({
    this.image,
    this.onBack,
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
                      child: _buildInstanceIcon(),
                    ),
                  ),
                  Padding(
                    padding: fieldMargin,
                    child: _buildUsernameField(l10n),
                  ),
                  Padding(
                    padding: fieldMargin,
                    child: _buildPasswordField(l10n),
                  ),
                  if (snapshot.hasError)
                    Padding(
                      padding: fieldMargin,
                      child: ErrorMessageWidget(
                        error: snapshot.error!,
                        stackTrace: snapshot.stackTrace,
                      ),
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
                        ElevatedButton(
                          onPressed: _onLogin,
                          style: Theme.of(context).filledButtonStyle.copyWith(
                                visualDensity: VisualDensity.comfortable,
                              ),
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

  TextFormField _buildPasswordField(AppLocalizations l10n) {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.surface.withOpacity(.75),
        filled: true,
        hintText: l10n.passwordFieldHint,
        prefixIcon: const Icon(Icons.vpn_key_rounded),
        prefixIconConstraints: iconConstraint,
        border: const OutlineInputBorder(),
        contentPadding: fieldPadding,
      ),
      // validator: widget.passwordValidator,
      keyboardType: TextInputType.text,
      autofillHints: const [AutofillHints.password],
      obscureText: true,
      validator: _validatePassword,
    );
  }

  TextFormField _buildUsernameField(AppLocalizations l10n) {
    return TextFormField(
      autofocus: true,
      controller: _usernameController,
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.surface.withOpacity(.75),
        filled: true,
        hintText: l10n.usernameFieldHint,
        prefixIcon: const Icon(Icons.person_rounded),
        prefixIconConstraints: iconConstraint,
        border: const OutlineInputBorder(),
        contentPadding: fieldPadding,
      ),
      autofillHints: const [AutofillHints.username],
      keyboardType: TextInputType.text,
      validator: _validateUsername,
    );
  }

  String? _validatePassword(String? value) {
    if (value?.trim().isNotEmpty == true) return null;
    return context.l10n.authNoPassword;
  }

  String? _validateUsername(String? value) {
    if (value?.trim().isNotEmpty == true) return null;
    return context.l10n.authNoUsername;
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

  Widget _buildInstanceIcon() {
    final url = widget.image;
    if (url != null) {
      final placeholder = _buildPlaceholder(true);
      final isSvg = url.toLowerCase().endsWith(".svg");
      if (isSvg) {
        return SvgPicture.network(
          url,
          width: _instanceIconSize,
          placeholderBuilder: (_) => placeholder,
        );
      }

      return Image.network(
        url,
        width: _instanceIconSize,
        cacheWidth: _instanceIconSize.toInt(),
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          return frame != null ? child : placeholder;
        },
        errorBuilder: (_, __, ___) => placeholder,
      );
    }

    return _buildPlaceholder(false);
  }

  Widget _buildPlaceholder(bool isLoading) {
    return Container(
      width: _instanceIconSize,
      height: _instanceIconSize,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: isLoading
          ? null
          : Icon(
              Icons.public,
              size: 64.0,
              color: Theme.of(context).colorScheme.onSurface,
            ),
    );
  }
}
