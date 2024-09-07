import '../../data/model/task_model.dart';
import '../entity/task_entity.dart';

abstract class TaskRepository {
  Future<List<TaskModel>> getTasks();
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
}
