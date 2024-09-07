import '../../data/model/task_model.dart';
import '../entity/task_entity.dart';
import '../repostories/task_repostories.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Future<List<TaskModel>> call() async {
    return await repository.getTasks();
  }
}
