import '../../data/model/task_model.dart';
import '../entity/task_entity.dart';
import '../repostories/task_repostories.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<void> call(Task task) async {
    return await repository.updateTask(task);
  }
}
