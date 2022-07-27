import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/instances.dart';
import 'package:kaiteki/fediverse/model/instance.dart';
import 'package:kaiteki/theming/default/colors.dart';
import 'package:kaiteki/ui/auth/discover_instances/discover_instance_screen_result.dart';
import 'package:kaiteki/ui/auth/discover_instances/discover_instances_screen.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:kaiteki/utils/lower_case_text_formatter.dart';
import 'package:tuple/tuple.dart';

typedef CredentialsCallback = void Function(
  String instance,
  String username,
  String password,
);

typedef IdValidationCallback = String? Function(
  String? instance,
  String? username,
);

typedef FetchInstanceCallback = Future<Instance?> Function(String instance);

const iconConstraint = BoxConstraints.tightFor(width: 48, height: 24);
const fieldMargin = EdgeInsets.symmetric(vertical: 8.0);
const fieldPadding = EdgeInsets.all(8.0);

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.onValidateInstance,
    required this.onValidateUsername,
    required this.onValidatePassword,
    required this.onLogin,
    this.enabled = true,
    this.currentError,
    required this.onFetchInstance,
    this.onResetInstance,
  });

  final bool enabled;

  final FormFieldValidator<String?> onValidateInstance;
  final FetchInstanceCallback onFetchInstance;
  final IdValidationCallback onValidateUsername;
  final FormFieldValidator<String?> onValidatePassword;
  final VoidCallback? onResetInstance;

  final CredentialsCallback onLogin;

  final Tuple2<dynamic, StackTrace?>? currentError;

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _instanceController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _transitionKey = GlobalKey();

  String? image;
  bool showAuthentication = false;

  @override
  Widget build(BuildContext context) {
    final currentError = widget.currentError;
    final errorColor = Theme.of(context).errorColor;
    return Column(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 64.0,
          ),
          child: PageTransitionSwitcher(
            key: _transitionKey,
            transitionBuilder: _buildTransition,
            duration: const Duration(milliseconds: 750),
            reverse: !showAuthentication,
            child: _buildPage(),
          ),
        ),
        if (currentError != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    currentError.item1.toString(),
                    style: TextStyle(color: errorColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: errorColor,
                  ),
                  splashRadius: 18,
                  tooltip: "View error details",
                  onPressed: () => context.showExceptionDialog(
                    currentError.item1,
                    currentError.item2,
                  ),
                )
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTransition(
    Widget child,
    Animation<double> primaryAnimation,
    Animation<double> secondaryAnimation,
  ) {
    return SharedAxisTransition(
      animation: primaryAnimation,
      secondaryAnimation: secondaryAnimation,
      transitionType: SharedAxisTransitionType.horizontal,
      fillColor: Colors.transparent,
      child: child,
    );
  }

  Future<void> onBackButtonPressed() async {
    if (showAuthentication) {
      setState(() => showAuthentication = false);

      // Remove instance data
      widget.onResetInstance?.call();
      image = null;
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> onNextButtonPressed() async {
    if (showAuthentication) {
      widget.onLogin.call(
        _instanceController.text,
        _usernameController.text,
        _passwordController.text,
      );
    } else {
      final instance = await widget.onFetchInstance.call(
        _instanceController.text,
      );

      if (instance == null) {
        return;
      }

      setState(() {
        image = instance.iconUrl ?? instance.mascotUrl;
        showAuthentication = true;
      });
    }
  }

  Widget _buildPage() {
    if (showAuthentication) {
      return _UserPage(
        usernameController: _usernameController,
        passwordController: _passwordController,
        usernameValidator: (username) => widget.onValidateUsername.call(
          _instanceController.text,
          username,
        ),
        passwordValidator: widget.onValidatePassword,
        image: image,
        onBack: onBackButtonPressed,
        onNext: onNextButtonPressed,
      );
    } else {
      return _InstancePage(
        instanceController: _instanceController,
        validator: widget.onValidateInstance,
        onNext: onNextButtonPressed,
      );
    }
  }
}

class _InstancePage extends StatefulWidget {
  final TextEditingController instanceController;
  final FormFieldValidator<String?> validator;
  final VoidCallback onNext;

  const _InstancePage({
    super.key,
    required this.instanceController,
    required this.validator,
    required this.onNext,
  });

  @override
  __InstancePageState createState() => __InstancePageState();
}

class __InstancePageState extends State<_InstancePage> {
  final _formKey = GlobalKey<FormState>();
  late bool _nextEnabled;
  List<InstanceData>? _instances;

  @override
  void initState() {
    super.initState();

    _nextEnabled = widget.validator(widget.instanceController.text) == null;

    fetchInstances().then(
      (list) => setState(() => _instances = list),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();
    return Form(
      key: _formKey,
      onChanged: _onFormChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: fieldMargin,
            child: TypeAheadFormField<InstanceData>(
              textFieldConfiguration: TextFieldConfiguration(
                // TODO(Craftplacer): `flutter_typeahead` is missing `autofillHints`
                // autofillHints: const [AutofillHints.url],
                controller: widget.instanceController,
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
                onSubmitted: (_) => _submit(),
              ),
              hideOnEmpty: true,
              validator: widget.validator,
              suggestionsCallback: _fetchSuggestions,
              onSuggestionSelected: (suggestion) {
                _submitWithInstance(suggestion.name);
              },
              itemBuilder: _buildSuggestionWidget,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: _onDiscoverInstancesPressed,
                child: Text(l10n.discoverInstancesButtonLabel),
              ),
              ElevatedButton(
                onPressed: _nextEnabled ? _submit : null,
                child: Text(l10n.nextButtonLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionWidget(BuildContext context, InstanceData itemData) {
    const fallbackIcon = Icon(Icons.public_rounded);
    return ListTile(
      leading: itemData.favicon == null
          ? fallbackIcon
          : Image.network(
              itemData.favicon!,
              width: 24,
              height: 24,
              errorBuilder: (_, __, ___) => fallbackIcon,
            ),
      title: Text(itemData.name),
    );
  }

  FutureOr<Iterable<InstanceData>> _fetchSuggestions(String pattern) {
    final instances = _instances;

    if (pattern.isEmpty || instances == null) {
      return [];
    }

    return instances.where((instance) {
      return instance.name.contains(pattern);
    });
  }

  void _onFormChanged() {
    final formState = _formKey.currentState;
    if (formState != null) {
      final isFormValid = formState.validate();
      if (_nextEnabled != isFormValid) {
        setState(() => _nextEnabled = isFormValid);
      }
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onNext.call();
    }
  }

  Future<void> _onDiscoverInstancesPressed() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DiscoverInstancesScreen(),
      ),
    );

    if (result is DiscoverInstanceScreenResult) {
      _submitWithInstance(result.instance);
      //if (!result.register) {}
    }
  }

  void _submitWithInstance(String instance) {
    widget.instanceController.text = instance;
    widget.onNext.call();
  }
}

class _UserPage extends StatefulWidget {
  final TextEditingController? usernameController;
  final TextEditingController? passwordController;
  final FormFieldValidator<String?>? usernameValidator;
  final FormFieldValidator<String?>? passwordValidator;
  final String? image;

  final VoidCallback? onBack;
  final VoidCallback? onNext;

  const _UserPage({
    super.key,
    this.usernameController,
    this.passwordController,
    this.usernameValidator,
    this.passwordValidator,
    this.image,
    this.onBack,
    this.onNext,
  });

  @override
  __UserPageState createState() => __UserPageState();
}

class __UserPageState extends State<_UserPage> {
  // ignore: prefer_final_fields
  bool _register = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: _getImageWidget(),
            ),
          ),
        ),
        if (_register)
          Padding(
            padding: fieldMargin,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: l10n.emailFieldHint,
                prefixIcon: const Icon(Icons.mail_rounded),
                prefixIconConstraints: iconConstraint,
                border: const OutlineInputBorder(),
                contentPadding: fieldPadding,
              ),
              autofillHints: const [AutofillHints.email],
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        Padding(
          padding: fieldMargin,
          child: TextFormField(
            autofocus: true,
            controller: widget.usernameController,
            decoration: InputDecoration(
              hintText: l10n.usernameFieldHint,
              prefixIcon: const Icon(Icons.person_rounded),
              prefixIconConstraints: iconConstraint,
              border: const OutlineInputBorder(),
              contentPadding: fieldPadding,
            ),
            validator: widget.usernameValidator,
            // ---
            autofillHints: const [AutofillHints.username],
            keyboardType: TextInputType.text,
          ),
        ),
        Padding(
          padding: fieldMargin,
          child: TextFormField(
            controller: widget.passwordController,
            decoration: InputDecoration(
              hintText: l10n.passwordFieldHint,
              prefixIcon: const Icon(Icons.vpn_key_rounded),
              prefixIconConstraints: iconConstraint,
              border: const OutlineInputBorder(),
              contentPadding: fieldPadding,
            ),
            validator: widget.passwordValidator,
            keyboardType: TextInputType.text,
            autofillHints: const [AutofillHints.password],
            obscureText: true,
          ),
        ),
        if (_register)
          TextFormField(
            decoration: InputDecoration(
              hintText: l10n.repeatPasswordFieldHint,
              prefixIcon: const Icon(Icons.vpn_key_rounded),
              prefixIconConstraints: iconConstraint,
              border: const OutlineInputBorder(),
              contentPadding: fieldPadding,
            ),
            validator: (input) {
              if (input != widget.passwordController!.text) {
                return l10n.authPasswordNoMatch;
              }
              return null;
            },
            keyboardType: TextInputType.text,
            autofillHints: const [AutofillHints.password],
            obscureText: true,
          ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              TextButton(
                onPressed: null,
                child: Text(l10n.forgotPasswordButtonLabel),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton(
                  onPressed: null,
                  child: Text(
                    _register
                        ? l10n.existingAccountButtonLabel
                        : l10n.createAccountButtonLabel,
                  ), //() => setState(() => _register = !_register),
                ),
              ),
              ElevatedButton(
                onPressed: widget.onNext,
                child: Text(
                  _register ? l10n.registerButtonLabel : l10n.loginButtonLabel,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getImageWidget() {
    const size = 96.0;

    final url = widget.image;
    if (url != null) {
      if (url.toLowerCase().endsWith(".svg")) {
        return SvgPicture.network(url, width: size);
      } else {
        return Image.network(
          url,
          width: size,
          filterQuality: FilterQuality.high,
        );
      }
    }

    return Container(
      width: size,
      height: size,
      color: kaitekiDarkBackground.shade500,
      child: const Icon(
        Icons.public,
        size: 64.0,
        color: Colors.white,
      ),
    );
  }
}
