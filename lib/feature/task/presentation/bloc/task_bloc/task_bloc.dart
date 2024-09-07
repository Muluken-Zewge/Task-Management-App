import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_list/feature/task/presentation/bloc/task_bloc/task_event.dart';
import 'package:task_list/feature/task/presentation/bloc/task_bloc/task_state.dart';

import '../../../domain/usecase/add_task_usecase.dart';
import '../../../domain/usecase/delete_task_usecase.dart';
import '../../../domain/usecase/get_task_usecase.dart';
import '../../../domain/usecase/update_task_usecase.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasksUseCase;
  final AddTask addTaskUseCase;
  final UpdateTask updateTaskUseCase;
  final DeleteTask deleteTaskUseCase;

  TaskBloc({
    required this.getTasksUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
  }) : super(TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<AddNewTaskEvent>(_onAddNewTask);
    on<UpdateExistingTaskEvent>(_onUpdateTask);
    on<DeleteTaskByIdEvent>(_onDeleteTask);
  }

  Future<void> _onLoadTasks(
      LoadTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await getTasksUseCase();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onAddNewTask(
      AddNewTaskEvent event, Emitter<TaskState> emit) async {
    await addTaskUseCase(event.task);
    add(LoadTasksEvent());
  }

  Future<void> _onUpdateTask(
      UpdateExistingTaskEvent event, Emitter<TaskState> emit) async {
    await updateTaskUseCase(event.task);
    add(LoadTasksEvent());
  }

  Future<void> _onDeleteTask(
      DeleteTaskByIdEvent event, Emitter<TaskState> emit) async {
    await deleteTaskUseCase(event.taskId);
    add(LoadTasksEvent());
  }
}
