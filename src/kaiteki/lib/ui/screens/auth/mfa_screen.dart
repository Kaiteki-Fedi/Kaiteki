import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/utils/extensions/string.dart';

class MfaScreen extends StatefulWidget {
  const MfaScreen({Key? key}) : super(key: key);

  @override
  _MfaScreenState createState() => _MfaScreenState();
}

class _MfaScreenState extends State<MfaScreen> {
  final TextEditingController _textController = TextEditingController();
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Multi-Factor-Authentication"),
      ),
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    autofillHints: const [AutofillHints.oneTimeCode],
                    controller: _textController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      counterStyle: TextStyle(
                        height: double.minPositive,
                      ),
                      counterText: '',
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.visiblePassword,
                    maxLength: 6,
                    style: GoogleFonts.robotoMono(fontSize: 24),
                    textInputAction: TextInputAction.done,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    autofocus: true,
                    autocorrect: false,
                  ),
                ),
              ),
              if (_error.isNotNullOrEmpty)
                Text(_error!, style: const TextStyle(color: Colors.redAccent)),
              ElevatedButton(
                child: const Text("Verify"),
                onPressed: () {
                  Navigator.of(context).pop(_textController.value.text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
