import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mdi/mdi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesScreen extends StatefulWidget {
  const SharedPreferencesScreen({Key? key}) : super(key: key);

  @override
  State<SharedPreferencesScreen> createState() =>
      _SharedPreferencesScreenState();
}

class _SharedPreferencesScreenState extends State<SharedPreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shared Preferences Manager"),
        actions: [
          IconButton(
            icon: const Icon(Mdi.delete),
            onPressed: () => setState(() => _clearPreferences(context)),
          ),
        ],
      ),
      body: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!.getKeys();
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final key = items.elementAt(i);
              final value = snapshot.data!.get(key);
              final icon = getIconForValue(value);

              return ListTile(
                leading: Icon(icon),
                title: Text(key, style: GoogleFonts.robotoMono()),
                trailing: IconButton(
                  icon: const Icon(Mdi.delete),
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

  Future<void> _clearPreferences(BuildContext context) async {
    final theme = Theme.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final instance = await SharedPreferences.getInstance();
    final result = await instance.clear();

    final message = result
        ? 'The shared preferences have been cleared.'
        : 'The shared preferences couldn\'t be cleared';
    final icon = result ? Mdi.check : Mdi.close;

    final snackBar = SnackBar(
      content: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              icon,
              color:
                  theme.snackBarTheme.contentTextStyle?.color ?? Colors.white,
            ),
          ),
          Text(message),
        ],
      ),
    );

    messenger.showSnackBar(snackBar);
  }
}
