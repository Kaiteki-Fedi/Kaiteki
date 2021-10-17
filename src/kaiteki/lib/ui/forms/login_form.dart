import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kaiteki/app_colors.dart';
import 'package:kaiteki/fediverse/model/instance.dart';
import 'package:kaiteki/ui/screens/discover_instances_screen.dart';
import 'package:kaiteki/utils/lower_case_text_formatter.dart';
import 'package:mdi/mdi.dart';

typedef CredentialsCallback = void Function(
  String instance,
  // ApiDefinition api,
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
    Key? key,
    required this.onValidateInstance,
    required this.onValidateUsername,
    required this.onValidatePassword,
    required this.onLogin,
    this.enabled = true,
    this.currentError,
    required this.onFetchInstance,
    this.onResetInstance,
  }) : super(key: key);

  final bool enabled;

  final FormFieldValidator<String?> onValidateInstance;
  final FetchInstanceCallback onFetchInstance;
  final IdValidationCallback onValidateUsername;
  final FormFieldValidator<String?> onValidatePassword;
  final VoidCallback? onResetInstance;

  final CredentialsCallback onLogin;

  final String? currentError;

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
    return Column(
      children: [
        PageTransitionSwitcher(
          key: _transitionKey,
          transitionBuilder: _buildTransition,
          duration: const Duration(milliseconds: 750),
          reverse: !showAuthentication,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 64.0,
            ),
            child: _buildPage(),
          ),
        ),
        if (widget.currentError != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.currentError!,
              style: TextStyle(color: Theme.of(context).errorColor),
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
      child: child,
      animation: primaryAnimation,
      secondaryAnimation: secondaryAnimation,
      transitionType: SharedAxisTransitionType.horizontal,
      fillColor: Colors.transparent,
    );
  }

  void onBackButtonPressed() async {
    if (showAuthentication) {
      setState(() => showAuthentication = false);

      // Remove instance data
      widget.onResetInstance?.call();
      image = null;
    } else {
      Navigator.pop(context);
    }
  }

  void onNextButtonPressed() async {
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
    Key? key,
    required this.instanceController,
    required this.validator,
    required this.onNext,
  }) : super(key: key);

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
                // TODO: `flutter_typeahead` is missing `autofillHints`
                // autofillHints: const [AutofillHints.url],
                controller: widget.instanceController,
                autofocus: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: fieldPadding,
                  hintText: "Instance",
                  prefixIcon: Icon(Mdi.earth),
                  prefixIconConstraints: iconConstraint,
                ),
                inputFormatters: [LowerCaseTextFormatter()],
                keyboardType: TextInputType.url,
                onSubmitted: (_) => _submit(),
              ),
              hideOnEmpty: true,
              getImmediateSuggestions: false,
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
                child: const Text('Discover instances'),
                onPressed: _onDiscoverInstancesPressed,
              ),
              ElevatedButton(
                child: const Text('Next'),
                onPressed: _nextEnabled ? _submit : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionWidget(BuildContext context, InstanceData itemData) {
    return ListTile(
      leading: itemData.favicon == null
          ? const Icon(Mdi.earth)
          : Image.network(
              itemData.favicon!,
              width: 24,
              height: 24,
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

  Iterable<InstanceData> _buildAutocompleteOptions(textEditingValue) {
    final instances = _instances;

    if (instances == null) {
      return [];
    }

    return instances.where((instance) {
      return instance.name.contains(textEditingValue.text);
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
    final result = await Navigator.of(context).pushNamed('/discover-instances');

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
    Key? key,
    this.usernameController,
    this.passwordController,
    this.usernameValidator,
    this.passwordValidator,
    this.image,
    this.onBack,
    this.onNext,
  }) : super(key: key);

  @override
  __UserPageState createState() => __UserPageState();
}

class __UserPageState extends State<_UserPage> {
  bool _register = false;

  @override
  Widget build(BuildContext context) {
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
              decoration: const InputDecoration(
                hintText: "E-mail address",
                prefixIcon: Icon(Mdi.email),
                prefixIconConstraints: iconConstraint,
                border: OutlineInputBorder(),
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
            decoration: const InputDecoration(
              hintText: "Username",
              prefixIcon: Icon(Mdi.account),
              prefixIconConstraints: iconConstraint,
              border: OutlineInputBorder(),
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
            decoration: const InputDecoration(
              hintText: "Password",
              prefixIcon: Icon(Mdi.key),
              prefixIconConstraints: iconConstraint,
              border: OutlineInputBorder(),
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
            decoration: const InputDecoration(
              hintText: "Repeat password",
              prefixIcon: Icon(Mdi.key),
              prefixIconConstraints: iconConstraint,
              border: OutlineInputBorder(),
              contentPadding: fieldPadding,
            ),
            validator: (input) {
              if (input != widget.passwordController!.text) {
                return "Passwords must match";
              }
            },
            keyboardType: TextInputType.text,
            autofillHints: const [AutofillHints.password],
            obscureText: true,
          ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              const TextButton(
                child: Text('Forgot password'),
                onPressed: null,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton(
                  child: _register
                      ? const Text('Log in with an existing account')
                      : const Text('Create a new account'),
                  onPressed:
                      null, //() => setState(() => _register = !_register),
                ),
              ),
              ElevatedButton(
                child: _register ? const Text('Register') : const Text('Login'),
                onPressed: widget.onNext,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getImageWidget() {
    const double size = 96.0;

    if (widget.image != null) {
      return Image.network(
        widget.image!,
        width: size,
        filterQuality: FilterQuality.high,
      );
    }

    return Container(
      width: size,
      height: size,
      color: AppColors.kaitekiDarkBackground.shade500,
      child: const Icon(
        Icons.public,
        size: 64.0,
        color: Colors.white,
      ),
    );
  }
}
