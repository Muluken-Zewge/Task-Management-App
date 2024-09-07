import '../../../data/model/task_model.dart';
import '../../../domain/entity/task_entity.dart';

abstract class TaskEvent {}

class LoadTasksEvent extends TaskEvent {}

class AddNewTaskEvent extends TaskEvent {
  final TaskModel task;

  AddNewTaskEvent(this.task);
}

class UpdateExistingTaskEvent extends TaskEvent {
  final Task task;

  UpdateExistingTaskEvent(this.task);
}

class DeleteTaskByIdEvent extends TaskEvent {
  final String taskId;

  DeleteTaskByIdEvent(this.taskId);
}
