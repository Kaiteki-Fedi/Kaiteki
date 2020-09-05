import 'package:flutter/material.dart';

class DebugScreen extends StatefulWidget {
  DebugScreen({Key key}) : super(key: key);

  @override
  _DebugScreenState createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  @override
  Widget build(BuildContext _) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Debug and Maintenance"),
      ),
      body: Column(
        children: [
          Material(
            elevation: 6,
            color: Colors.red,
            child: ListTile(
              title: Text("Please proceed here with caution as some settings might have unintended behavior or delete your user settings."),
            ),
          ),
        ],
      ),
    );
  }
}