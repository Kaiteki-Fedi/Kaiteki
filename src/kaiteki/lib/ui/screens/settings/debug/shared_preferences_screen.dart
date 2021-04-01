import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mdi/mdi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesScreen extends StatefulWidget {
  const SharedPreferencesScreen({Key? key}) : super(key: key);

  @override
  _SharedPreferencesScreenState createState() =>
      _SharedPreferencesScreenState();
}

class _SharedPreferencesScreenState extends State<SharedPreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shared Preferences Manager"),
        actions: [
          IconButton(
            icon: Icon(Mdi.delete),
            onPressed: () => setState(() => _clearPreferences(context)),
          ),
        ],
      ),
      body: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          var items = snapshot.data!.getKeys();
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              var key = items.elementAt(i);
              var value = snapshot.data!.get(key);
              var icon = getIconForValue(value);

              return ListTile(
                leading: Icon(icon),
                title: Text(key, style: GoogleFonts.robotoMono()),
                trailing: IconButton(
                  icon: Icon(Mdi.delete),
                  onPressed: () => setState(() => snapshot.data!.remove(key)),
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData getIconForValue(dynamic value) {
    if (value is String) return Mdi.textBox;
    if (value is List<String>) return Mdi.textBoxMultiple;
    if (value is bool) return Mdi.checkboxMarked;
    if (value is double) return Mdi.numeric0BoxMultiple;
    if (value is int) return Mdi.numeric0Box;

    return Mdi.wrench;
  }

  void _clearPreferences(BuildContext context) async {
    var instance = await SharedPreferences.getInstance();
    var result = await instance.clear();

    var message = result
        ? 'The shared preferences have been cleared.'
        : 'The shared preferences couldn\'t be cleared';
    var icon = result ? Mdi.check : Mdi.close;

    var snackBar = SnackBar(
      content: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              icon,
              color: Theme.of(context).snackBarTheme.contentTextStyle?.color
                  ?? Colors.white,
            ),
          ),
          Text(message),
        ],
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
