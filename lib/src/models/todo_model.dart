import 'package:hive_flutter/hive_flutter.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 1)
class TodoModel {
  @HiveField(0)
  String title;

  @HiveField(1)
  String desc;

  @HiveField(2)
  bool isFinished;

  TodoModel({
    required this.title,
    required this.desc,
    required this.isFinished,
  });

  factory TodoModel.empty() =>
      TodoModel(title: '', desc: '', isFinished: false);
}
