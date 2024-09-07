import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_list/feature/task/domain/entity/task_entity.dart';

import '../model/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks();
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  static const String _tasksKey = 'tasks';
  final SharedPreferences _preferences;

  TaskLocalDataSourceImpl(this._preferences);

  @override
  Future<List<TaskModel>> getTasks() async {
    final jsonString = _preferences.getString(_tasksKey);
    print(jsonString);
    if (jsonString == null) {
      return [];
    }
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => TaskModel.fromJson(json)).toList();
  }

  @override
  Future<void> addTask(TaskModel task) async {
    final tasks = await getTasks();
    final updatedTasks = [...tasks, task];
    await _saveTasks(updatedTasks);
  }

  @override
  Future<void> updateTask(Task task) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = TaskModel(
          id: task.id,
          title: task.title,
          description: task.description,
          isDone: task.isDone,
          dueDate: task.dueDate);
      await _saveTasks(tasks);
    } else {
      throw Exception('Task not found');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    final tasks = await getTasks();
    final updatedTasks = tasks.where((task) => task.id != id).toList();
    await _saveTasks(updatedTasks);
  }

  Future<void> _saveTasks(List<TaskModel> tasks) async {
    final jsonList = tasks.map((task) => task.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await _preferences.setString(_tasksKey, jsonString);
  }
}
