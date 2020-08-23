import 'package:flutter/material.dart';
import 'package:kaiteki/api/model/misskey/pages/misskey_page.dart';
import 'package:kaiteki/api/model/misskey/pages/misskey_page_sandbox.dart';
import 'package:mdi/mdi.dart';

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
    sandbox = MisskeyPageSandbox(
      widget.page,
      onRebuildRequired: () {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.page.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: sandbox.build(context),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 4,
              children: [
                Text(widget.page.user.username),
                IconButton(icon: Icon(Mdi.heartOutline, size: 18)),
                FlatButton(child: Text("Edit this page")),
                FlatButton(child: Text("Pin to profile")),
                FlatButton(child: Text("View source")),
              ],
            ),
          )
        ],
      ),
    );
  }
}