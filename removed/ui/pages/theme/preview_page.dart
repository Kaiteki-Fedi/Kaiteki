import 'package:flutter/material.dart';
import 'package:kaiteki/model/fediverse/post.dart';
import 'package:kaiteki/ui/widgets/status_widget.dart';

class PreviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        StatusWidget(Post.example()),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Control Preview",
                  style: Theme.of(context).textTheme.headline4),
              Row(
                children: [
                  RaisedButton(
                    child: Text("Button"),
                    onPressed: () {},
                  ),
                  RaisedButton(
                    child: Text("Disabled Button"),
                    onPressed: null,
                  )
                ],
              ),
              TextField(
                decoration: InputDecoration(hintText: "Test Input Field"),
              ),
            ],
          ),
        )
      ],
    );
  }
}
