import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_list/feature/quotes/data/datasource/quote_remote_datasource.dart';
import 'package:task_list/feature/quotes/data/repostories/quote_repostory_imp.dart';
import 'package:task_list/feature/quotes/domain/repostory/quote_repostory.dart';
import 'package:task_list/feature/quotes/domain/usecase/get_random_quote_use_case.dart';
import 'package:task_list/feature/quotes/presentation/bloc/quotes_bloc/quotes_bloc.dart';
import 'package:task_list/feature/task/data/datasource/task_local_datasource.dart';
import 'package:task_list/feature/task/data/repostories/task_repostory_imp.dart';
import 'package:task_list/feature/task/domain/repostories/task_repostories.dart';
import 'package:task_list/feature/task/domain/usecase/add_task_usecase.dart';
import 'package:task_list/feature/task/domain/usecase/delete_task_usecase.dart';
import 'package:task_list/feature/task/domain/usecase/get_task_usecase.dart';
import 'package:task_list/feature/task/domain/usecase/update_task_usecase.dart';
import 'package:task_list/feature/task/presentation/bloc/task_bloc/task_bloc.dart';
import 'package:http/http.dart' as http;

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //! Feature_#1 Task ----------------------------------------
// Bloc
  serviceLocator.registerFactory(
    () => TaskBloc(
        getTasksUseCase: serviceLocator(),
        addTaskUseCase: serviceLocator(),
        updateTaskUseCase: serviceLocator(),
        deleteTaskUseCase: serviceLocator()),
  );

  // Usecase
  serviceLocator.registerLazySingleton(
    () => GetTasks(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => AddTask(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => UpdateTask(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => DeleteTask(
      serviceLocator(),
    ),
  );
  // Repository
  serviceLocator.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      serviceLocator(),
    ),
  );

  // Datasource

  serviceLocator.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(serviceLocator()),
  );
  //! Feature_#1 Quotes ----------------------------------------
// Bloc
  serviceLocator.registerFactory(
    () => QuoteBloc(serviceLocator()),
  );

  // Usecase
  serviceLocator.registerLazySingleton(
    () => GetRandomQuoteUseCase(
      serviceLocator(),
    ),
  );

  // Repository
  serviceLocator.registerLazySingleton<QuoteRepository>(
    () => QuoteRepositoryImpl(
      serviceLocator(),
    ),
  );

  // Datasource

  serviceLocator.registerLazySingleton<QuoteRemoteDataSource>(
    () => QuoteRemoteDataSourceImpl(serviceLocator()),
  );

// External
  final prefs = await SharedPreferences.getInstance();
  serviceLocator.registerFactory(() => prefs);
  serviceLocator.registerFactory(() => http.Client());
}
