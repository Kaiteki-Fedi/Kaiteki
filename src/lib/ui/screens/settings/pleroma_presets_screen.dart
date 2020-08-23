import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kaiteki/api/model/pleroma/theme.dart';
import 'package:http/http.dart' as http;
import 'package:kaiteki/ui/widgets/theme_preview_widget.dart';

class PleromaPresetsScreen extends StatefulWidget {
  PleromaPresetsScreen({Key key}) : super(key: key);

  @override
  _PleromaPresetsScreenState createState() => _PleromaPresetsScreenState();
}

class _PleromaPresetsScreenState extends State<PleromaPresetsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Preset"),
        // bottom: ,
      ),
      body: FutureBuilder(
        future: getPresets(),
        builder: (_, AsyncSnapshot<Iterable<String>> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView.separated(
            separatorBuilder: (_, i) => Divider(),
            itemCount: snapshot.data.length,
            itemBuilder: (_, i) {
              if (snapshot.data == null)
                return Text("null...");

              var themeUrl = snapshot.data.elementAt(i);
              return FutureBuilder(
                future: getTheme(themeUrl),
                builder: (_, AsyncSnapshot<PleromaTheme> snapshot) {
                  return InkWell(
                    onTap: () => Navigator.of(context).pop(snapshot.data),
                    child: Ink(
                      height: 200,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(4),
                        elevation: 4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: getWidget(snapshot)
                        ),
                      ),
                    )
                  );
                },
              );
            }
          );
        },
      ),
    );
  }

  Widget getWidget(AsyncSnapshot<PleromaTheme> snapshot) {
    if (snapshot.hasData) {
      return ThemePreviewWidget(snapshot.data);
    } else {
      return ThemePreviewWidget(null, defaultName: "Loading");
    }
  }

  Future<Iterable<String>> getPresets() async {
    var response = await http.get("https://fedi.absturztau.be/static/styles.json");
    var json = jsonDecode(response.body);
    var object = json
        .values
        .where((v) => v is String)
        .cast<String>();

    return object;
  }

  Future<PleromaTheme> getTheme(String url) async {
    print("Downloading $url");

    var themeResponse = await http.get("https://fedi.absturztau.be$url");
    var json = jsonDecode(themeResponse.body);

    return PleromaTheme.fromJson(json);
  }
}