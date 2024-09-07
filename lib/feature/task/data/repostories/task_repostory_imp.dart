import 'package:task_list/feature/task/data/model/task_model.dart';

import '../../domain/entity/task_entity.dart';
import '../../domain/repostories/task_repostories.dart';
import '../datasource/task_local_datasource.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource dataSource;

  TaskRepositoryImpl(this.dataSource);

  @override
  Future<List<TaskModel>> getTasks() async {
    return await dataSource.getTasks();
  }

  @override
  Future<void> addTask(TaskModel task) async {
    return await dataSource.addTask(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    return await dataSource.updateTask(task);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    return await dataSource.deleteTask(taskId);
  }
}
