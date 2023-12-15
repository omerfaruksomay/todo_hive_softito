import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/src/models/todo_model.dart';
import 'package:todo_hive/src/services/hive_service.dart';
import 'package:todo_hive/src/widgets/custom_form_widget.dart';

class TodoListWidget extends StatefulWidget {
  final Box box;
  final TodoModel model;
  final GlobalKey<FormState> formKey;
  const TodoListWidget(
      {super.key,
      required this.box,
      required this.model,
      required this.formKey});

  @override
  State<TodoListWidget> createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.box.listenable(),
      builder: (context, value, child) {
        return ListView.builder(
          itemCount: widget.box.values.length,
          itemBuilder: (context, index) {
            final element = widget.box.values.elementAt(index);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.grey.shade700,
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: CustomFormWidget(
                          onPressed: () async {
                            await HiveService.update(
                                widget.box, index, widget.model);
                            Navigator.pop(context);
                          },
                          buttonText: 'Update Todo',
                          formKey: widget.formKey,
                          model: widget.model,
                          index: index,
                          box: widget.box,
                        ),
                      );
                    },
                  );
                },
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                leading: Checkbox(
                  checkColor: Colors.black,
                  fillColor: const MaterialStatePropertyAll(Colors.white),
                  value: element.isFinished,
                  onChanged: (value) {
                    setState(() {
                      element.isFinished = !element.isFinished;
                    });
                  },
                ),
                tileColor: Colors.black,
                title: Text(
                  element.title,
                  style: TextStyle(
                    decorationColor: Colors.white,
                    decoration: element.isFinished
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  element.desc,
                  style: TextStyle(
                    decorationColor: Colors.white,
                    decoration: element.isFinished
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: Colors.white,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    HiveService.remove(widget.box, index);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
