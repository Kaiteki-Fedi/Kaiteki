import 'package:flutter/material.dart';
import 'package:kaiteki/ui/widgets/instance_list_widget.dart';
import 'package:kaiteki/ui/widgets/layout/form_widget.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({Key? key}) : super(key: key);

  @override
  _AddAccountScreenState createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select instance type")),
      body: FormWidget(
        padding: EdgeInsets.zero,
        child: InstanceListWidget(),
      ),
    );
  }
}
