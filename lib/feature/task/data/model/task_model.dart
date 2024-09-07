import '../../domain/entity/task_entity.dart';

class TaskModel extends Task {
  TaskModel({
    required String id,
    required String title,
    required String description,
    required DateTime dueDate,
    bool isDone = false,
  }) : super(
          id: id,
          title: title,
          description: description,
          dueDate: dueDate,
          isDone: isDone,
        );

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      isDone: json['isDone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isDone': isDone,
    };
  }
}
