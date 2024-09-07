import '../repostories/task_repostories.dart';

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<void> call(String taskId) async {
    return await repository.deleteTask(taskId);
  }
}
