import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/src/models/todo_model.dart';
import 'package:todo_hive/src/widgets/todo_list_widget.dart';

class TodoListPage extends StatefulWidget {
  final bool boxLoaded;
  final Box box;
  final TodoModel model;
  final GlobalKey<FormState> formKey;
  const TodoListPage(
      {super.key,
      required this.boxLoaded,
      required this.box,
      required this.model,
      required this.formKey});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  Widget build(BuildContext context) {
    return widget.boxLoaded
        ? TodoListWidget(
            box: widget.box,
            model: widget.model,
            formKey: widget.formKey,
          )
        : const Text('Erorr');
  }
}
