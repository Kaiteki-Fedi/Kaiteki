import 'package:flutter/material.dart';
import 'package:kaiteki/api/model/misskey/pages/misskey_page.dart';
import 'package:kaiteki/api/model/misskey/pages/misskey_page_sandbox.dart';

class MisskeyPageScreen extends StatefulWidget {
  MisskeyPageScreen(this.page, {Key key}) : super(key: key);

  final MisskeyPage page;

  @override
  _MisskeyPageScreenState createState() => _MisskeyPageScreenState();
}

class _MisskeyPageScreenState extends State<MisskeyPageScreen> {
  MisskeyPageSandbox sandbox;

  @override
  void initState() {
    super.initState();
    sandbox = MisskeyPageSandbox(widget.page, onRebuildRequired: () => setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.page.title),
      ),
      body: sandbox.build(context),
    );
  }
}