import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/src/models/todo_model.dart';
import 'package:todo_hive/src/services/hive_service.dart';

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
          ? ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, value, child) {
                return ListView.builder(
                  itemCount: box.values.length,
                  itemBuilder: (context, index) {
                    final element = box.values.elementAt(index);
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
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        cursorColor: Colors.black,
                                        style: const TextStyle(
                                            color: Colors.white),
                                        decoration: InputDecoration(
                                          labelStyle: const TextStyle(
                                              color: Colors.white),
                                          labelText: 'Todo title',
                                          hintText: model.title,
                                          hintStyle: const TextStyle(
                                              color: Colors.white),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                        ),
                                        onChanged: (value) =>
                                            model.title = value,
                                      ),
                                      const SizedBox(height: 40),
                                      TextFormField(
                                        cursorColor: Colors.black,
                                        style: const TextStyle(
                                            color: Colors.white),
                                        decoration: InputDecoration(
                                          labelStyle: const TextStyle(
                                              color: Colors.white),
                                          labelText: 'Todo description',
                                          hintText: model.desc,
                                          hintStyle: const TextStyle(
                                              color: Colors.white),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                        ),
                                        onChanged: (value) =>
                                            model.desc = value,
                                      ),
                                      const SizedBox(height: 40),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await HiveService.update(
                                              box, index, model);
                                          Navigator.pop(context);
                                        },
                                        style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.black),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.save,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'Update Todo',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.white),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.close,
                                              color: Colors.black,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'Close',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        shape: RoundedRectangleBorder(
                          //<-- SEE HERE
                          side: const BorderSide(width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        leading: Checkbox(
                          checkColor: Colors.black,
                          fillColor:
                              const MaterialStatePropertyAll(Colors.white),
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
                              HiveService.remove(box, index);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            )),
                      ),
                    );
                  },
                );
              },
            )
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
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        cursorColor: Colors.black,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(color: Colors.white),
                          labelText: 'Todo title',
                          hintText: 'Enter todo title',
                          hintStyle: TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        onChanged: (value) => model.title = value,
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        cursorColor: Colors.black,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(color: Colors.white),
                          labelText: 'Todo description',
                          hintText: 'Enter todo description',
                          hintStyle: TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        onChanged: (value) => model.desc = value,
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () async {
                          await HiveService.writeToBox(box, model);
                          model = TodoModel.empty();
                          Navigator.pop(context);
                        },
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.black),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Save Todo',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.white),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.close,
                              color: Colors.black,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Close',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
