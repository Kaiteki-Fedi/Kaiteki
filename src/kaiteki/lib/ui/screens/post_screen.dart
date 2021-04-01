import 'package:flutter/material.dart';
import 'package:kaiteki/ui/forms/post_form.dart';
import 'package:mdi/mdi.dart';

class PostScreen extends StatefulWidget {
  PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Post new status"),
          actions: [
            IconButton(
              icon: Icon(Mdi.send),
              onPressed: null,
            )
          ],
        ),
        body: PostForm());
  }
}
