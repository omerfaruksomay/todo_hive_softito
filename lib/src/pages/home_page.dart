import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_hive/src/models/todo_model.dart';
import 'package:todo_hive/src/pages/todo_filter_page.dart';
import 'package:todo_hive/src/pages/todo_list_page.dart';
import 'package:todo_hive/src/services/hive_service.dart';
import 'package:todo_hive/src/widgets/custom_form_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
        backgroundColor: Colors.grey.shade700,
        appBar: AppBar(
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: TextStyle(color: Colors.white),
            tabs: [
              Tab(
                text: 'Todo List',
              ),
              Tab(
                text: 'Search from todo list',
              ),
            ],
          ),
          backgroundColor: Colors.black,
          title: const Text(
            'Todo App',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: TabBarView(
          children: [
            TodoListPage(
              boxLoaded: boxLoaded,
              box: box,
              model: model,
              formKey: formKey,
            ),
            TodoFilterPage(
              box: box,
              formKey: formKey,
              model: model,
              boxLoaded: boxLoaded,
            ),
          ],
        ),
      ),
    );
  }
}
