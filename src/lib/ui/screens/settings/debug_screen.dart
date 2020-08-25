import 'package:flutter/material.dart';
import 'package:kaiteki/account_container.dart';
import 'package:provider/provider.dart';

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
          Builder(
            builder: (context) => ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                ListTile(
                  title: Text("Reset and clear account container"),
                  onTap: () async {
                    var container = Provider.of<AccountContainer>(context, listen: false);
                    container.clear();
                    container.reset();

                    final snackBar = SnackBar(
                      content: Text('Account container was reset'),
                    );

                    Scaffold.of(context).showSnackBar(snackBar);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}