import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kaiteki/api/clients/pleroma_client.dart';
import 'package:kaiteki/utils/string_extensions.dart';
import 'package:provider/provider.dart';

class MfaScreen extends StatefulWidget {
  MfaScreen({this.mfaToken, Key key}) : super(key: key);

  final String mfaToken;

  @override
  _MfaScreenState createState() => _MfaScreenState();
}

class _MfaScreenState extends State<MfaScreen> {
  TextEditingController _textController = TextEditingController();

  String _error;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Multi-Factor-Authentication"),
        centerTitle: true,
      ),
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textController,
              keyboardType: TextInputType.visiblePassword,
              maxLength: 6,
              maxLengthEnforced: true,
              style: TextStyle(fontSize: 32),
              decoration: InputDecoration(

              ),
            ),
            if (_error.isNotNullOrEmpty)
              Text(_error, style: TextStyle(color: Colors.redAccent)),
            RaisedButton(
              child: Text("Verify"),
              onPressed: _loading ? null : verify,
            ),
          ],
        ),
      )
    );
  }

  void setLoading(bool value) {
    setState(() => _loading = value);
  }

  void setError(String errorMessage) {
    setState(() => _error = errorMessage);
  }

  void verify() async {
    try {
      setLoading(true);

      var client = Provider.of<PleromaClient>(context, listen: false);
      var response = await client.respondMfa(
          widget.mfaToken,
          int.parse(_textController.value.text)
      );

      if (response.error.isNotNullOrEmpty) {
        setError(response.error);
        return;
      }

      Navigator.pop(context);
    } catch (e) {
      setError("Authentication process failed:\n${e.toString()}");
    } finally {
      setLoading(false);
    }
  }
}