import 'package:flutter/material.dart';
import 'package:kaiteki/ui/forms/post_form.dart';
import 'package:mdi/mdi.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post new status"),
        actions: const [
          IconButton(
            icon: Icon(Mdi.send),
            onPressed: null,
          )
        ],
      ),
      body: const PostForm(),
    );
  }
}
