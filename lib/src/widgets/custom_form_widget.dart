import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/src/models/todo_model.dart';

class CustomFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TodoModel model;
  final int? index;
  final Box box;
  final String buttonText;
  final void Function() onPressed;

  const CustomFormWidget(
      {super.key,
      required this.formKey,
      required this.model,
      this.index,
      required this.box,
      required this.buttonText,
      required this.onPressed});
  @override
  State<CustomFormWidget> createState() => _CustomFormWidgetState();
}

class _CustomFormWidgetState extends State<CustomFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextFormField(
            cursorColor: Colors.black,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.white),
              labelText: 'Todo title',
              hintText: widget.model.title,
              hintStyle: const TextStyle(color: Colors.white),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onChanged: (value) => widget.model.title = value,
          ),
          const SizedBox(height: 40),
          TextFormField(
            cursorColor: Colors.black,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.white),
              labelText: 'Todo description',
              hintText: widget.model.desc,
              hintStyle: const TextStyle(color: Colors.white),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onChanged: (value) => widget.model.desc = value,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: widget.onPressed,
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.black),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.buttonText,
                  style: const TextStyle(color: Colors.white),
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
              backgroundColor: MaterialStatePropertyAll(Colors.white),
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
    );
  }
}
