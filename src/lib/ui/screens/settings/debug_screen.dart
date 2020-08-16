import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
                  title: Text("Clear secure storage"),
                  subtitle: Text("This will clear your secure storage and refresh your account container, this will most likely log out of all of your accounts."),

                  isThreeLine: true,
                  onTap: () async {
                    try {
                      await FlutterSecureStorage().deleteAll();

                      final snackBar = SnackBar(
                        content: Text('Secure storage has been cleared'),
                      );

                      Scaffold.of(context).showSnackBar(snackBar);
                    } catch (e) {
                      final snackBar = SnackBar(
                        content: ListTile(
                          title: Text('Failed to clear secure storage'),
                          subtitle: Text(e.toString()),
                        ),
                      );

                      Scaffold.of(context).showSnackBar(snackBar);
                    }
                  },
                ),
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