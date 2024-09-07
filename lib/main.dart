import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_list/feature/quotes/presentation/bloc/quotes_bloc/quotes_bloc.dart';
import 'package:task_list/feature/task/presentation/bloc/task_bloc/task_event.dart';
import 'package:task_list/injection_container.dart';
import 'feature/quotes/presentation/bloc/quotes_bloc/quotes_event.dart';
import 'feature/task/presentation/bloc/task_bloc/task_bloc.dart';
import 'feature/task/presentation/screen/home_navigation.dart';
import 'feature/task/presentation/screen/home_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(
    MultiBlocProvider(providers: [
      BlocProvider<TaskBloc>(
          create: (_) => serviceLocator<TaskBloc>()..add(LoadTasksEvent())),
      BlocProvider<QuoteBloc>(
          create: (_) => serviceLocator<QuoteBloc>()..add(LoadQuoteEvent()))
    ], child: const MyApp()),
  );
}

Future<void> requestNotificationPermissions() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // For Android 13 and above, request permission
  final NotificationAppLaunchDetails? appLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (appLaunchDetails != null && appLaunchDetails.didNotificationLaunchApp) {
    // The app was launched via a notification
    print('App was launched via a notification.');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePageNavigator(),
    );
  }
}
