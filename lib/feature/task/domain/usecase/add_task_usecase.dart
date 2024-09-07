import '../../data/model/task_model.dart';
import '../entity/task_entity.dart';
import '../repostories/task_repostories.dart';

class AddTask {
  final TaskRepository repository;

  AddTask(this.repository);

  Future<void> call(TaskModel task) async {
    return await repository.addTask(task);
  }
}
