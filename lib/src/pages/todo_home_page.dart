import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/src/models/todo_model.dart';
import 'package:todo_hive/src/services/hive_service.dart';
import 'package:todo_hive/src/widgets/custom_form_widget.dart';
import 'package:todo_hive/src/widgets/todo_list_widget.dart';

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final formKey = GlobalKey<FormState>();
  late final Box<TodoModel> box;

  bool boxLoaded = false;

  TodoModel model = TodoModel.empty();

  initLocalDb() async {
    final result = await HiveService.initService();
    box = await HiveService.openBox<TodoModel>('todos');
    setState(() {
      boxLoaded = true;
    });
    print(result ? 'Connected' : 'cant connect');
  }

  @override
  void initState() {
    super.initState();
    initLocalDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Todo App',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: boxLoaded
          ? TodoListWidget(box: box, model: model, formKey: formKey)
          : const Text('Erorr'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          size: 45,
          color: Colors.white,
        ),
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: Colors.grey.shade700,
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(50.0),
                child: CustomFormWidget(
                  formKey: formKey,
                  model: model,
                  box: box,
                  buttonText: 'Save Todo',
                  onPressed: () async {
                    await HiveService.writeToBox(box, model);
                    Navigator.pop(context);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
