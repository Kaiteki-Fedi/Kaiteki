import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kaiteki/utils/string_extensions.dart';

class MfaScreen extends StatefulWidget {
  MfaScreen({Key key}) : super(key: key);

  @override
  _MfaScreenState createState() => _MfaScreenState();
}

class _MfaScreenState extends State<MfaScreen> {
  TextEditingController _textController = TextEditingController();
  String _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Multi-Factor-Authentication"),
      ),
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textController,
              autofillHints: [ AutofillHints.oneTimeCode ],
              keyboardType: TextInputType.visiblePassword,
              maxLength: 6,
              maxLengthEnforced: true,
              style: TextStyle(fontSize: 32),
            ),

            if (_error.isNotNullOrEmpty)
              Text(_error, style: TextStyle(color: Colors.redAccent)),

            RaisedButton(
              child: Text("Verify"),
              onPressed: () => Navigator.of(context).pop(_textController.value.text),
            ),
          ],
        ),
      )
    );
  }
}