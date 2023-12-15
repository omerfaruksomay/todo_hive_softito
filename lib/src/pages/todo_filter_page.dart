import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_hive/src/models/todo_model.dart';
import 'package:todo_hive/src/pages/todo_list_page.dart';

class TodoFilterPage extends StatefulWidget {
  final Box box;
  final TodoModel model;
  final GlobalKey<FormState> formKey;
  final bool boxLoaded;
  const TodoFilterPage(
      {super.key,
      required this.box,
      required this.model,
      required this.formKey,
      required this.boxLoaded});

  @override
  State<TodoFilterPage> createState() => _TodoFilterPageState();
}

class _TodoFilterPageState extends State<TodoFilterPage> {
  final TextEditingController _titleContoller = TextEditingController();
  String? todoTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            color: Colors.grey.shade700,
            child: Column(
              children: [
                TextField(
                  controller: _titleContoller,
                  cursorColor: Colors.black,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    labelText: 'Todo description',
                    hintStyle: TextStyle(color: Colors.white),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white)),
                  onPressed: () {
                    setState(() {
                      todoTitle = _titleContoller.text;
                    });
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Filter',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TodoListPage(
              boxLoaded: widget.boxLoaded,
              box: widget.box,
              model: widget.model,
              formKey: widget.formKey,
            ),
          ),
        ],
      ),
    );
  }
}
